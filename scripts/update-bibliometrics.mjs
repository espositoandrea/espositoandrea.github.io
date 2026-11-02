#!/usr/bin/env node
// Refreshes _data/bibliometrics.yml (`npm run bibliometrics`):
//   Google Scholar  scraped from the public profile page (no key needed)
//   Scopus          Elsevier's Author Retrieval API; needs an API key
//
// Scopus API key (never commit it):
//   1. Sign in at https://dev.elsevier.com/ (with your institutional account) and create
//      a key under "My API Key" -> "Create API key".
//   2. Put it in a `.env` file at the root of the repository (git-ignored):
//        SCOPUS_API_KEY=your-key
//      or export it in the shell: `SCOPUS_API_KEY=your-key npm run bibliometrics`.
//   3. If Elsevier answers 401/403, the request must come from an institutional network
//      (e.g. the university VPN), or carry an institutional token: add
//      `SCOPUS_INSTTOKEN=...` (request it from Elsevier) next to the key.
// Only the numbers and `updated` change: comments and layout of the file are kept.
// A source that fails (or has no key) is skipped with a warning and keeps its old values.
//
//   node scripts/update-bibliometrics.mjs [--dry-run]

import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";

const FILE = path.join(path.dirname(fileURLToPath(import.meta.url)), "..", "_data", "bibliometrics.yml");
const dryRun = process.argv.includes("--dry-run");
// Optional .env file at the repository root (git-ignored); variables already in the shell win
try {
  process.loadEnvFile(path.join(path.dirname(FILE), "..", ".env"));
} catch {}
const yaml = createRequire(import.meta.url)("js-yaml");

let text = await readFile(FILE, "utf8");
const current = yaml.load(text);

// Sets `key` inside the top-level block `block` (optionally under `sub`), keeping everything else as is
function setValue(block, sub, key, value) {
  const lines = text.split("\n");
  const start = lines.findIndex((l) => l.startsWith(`${block}:`));
  let i = start + 1;
  const inBlock = (l) => l === "" || /^\s/.test(l);
  if (sub) {
    while (inBlock(lines[i]) && !lines[i].startsWith(`  ${sub}:`)) i++;
  }
  const indent = sub ? "    " : "  ";
  for (; i < lines.length && inBlock(lines[i]); i++) {
    if (lines[i].startsWith(`${indent}${key}:`)) {
      lines[i] = `${indent}${key}: ${value}`;
      text = lines.join("\n");
      return;
    }
  }
  throw new Error(`${block}${sub ? "." + sub : ""}.${key} not found in ${FILE}`);
}

async function scholar() {
  const id = current.googleScholar.id;
  const res = await fetch(`https://scholar.google.com/citations?user=${id}&hl=en`, {
    headers: { "User-Agent": "Mozilla/5.0 (compatible; bibliometrics-updater)" },
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  // The stats table has 6 cells: citations, hindex, i10index, each as "all time" then "since <year>"
  const cells = [...(await res.text()).matchAll(/gsc_rsb_std">(\d+)</g)].map((m) => Number(m[1]));
  if (cells.length < 6) throw new Error("stats table not found (blocked by a captcha?)");
  return { citations: cells[0], hindex: cells[2], i10index: cells[4] };
}

async function scopus() {
  const key = process.env.SCOPUS_API_KEY;
  if (!key) throw new Error("SCOPUS_API_KEY is not set");
  const headers = { "X-ELS-APIKey": key, Accept: "application/json" };
  if (process.env.SCOPUS_INSTTOKEN) headers["X-ELS-Insttoken"] = process.env.SCOPUS_INSTTOKEN;
  const url = `https://api.elsevier.com/content/author/author_id/${current.scopus.id}?view=METRICS`;
  const res = await fetch(url, { headers });
  if (!res.ok) throw new Error(`HTTP ${res.status} ${await res.text().then((t) => t.slice(0, 200))}`);
  const r = (await res.json())["author-retrieval-response"][0];
  const num = (v) => Number(v);
  return {
    documents: num(r.coredata["document-count"]),
    total: num(r.coredata["citation-count"]),
    citingDocuments: num(r.coredata["cited-by-count"]),
    hindex: num(r["h-index"]),
    coauthors: num(r["coauthor-count"]),
  };
}

let changed = 0;
function report(label, oldV, newV) {
  console.log(`  ${label.padEnd(26)} ${String(oldV).padStart(5)} -> ${newV}${oldV === newV ? "" : "  *"}`);
  if (oldV !== newV) changed++;
}

try {
  console.log("Google Scholar");
  const s = await scholar();
  for (const k of ["citations", "hindex", "i10index"]) {
    report(k, current.googleScholar[k], s[k]);
    setValue("googleScholar", null, k, s[k]);
  }
} catch (e) {
  console.warn(`Google Scholar skipped: ${e.message}`);
}

try {
  console.log("Scopus");
  const s = await scopus();
  const map = [
    ["documents", null, "documents", current.scopus.documents, s.documents],
    ["citations.total", "citations", "total", current.scopus.citations.total, s.total],
    ["citations.documents", "citations", "documents", current.scopus.citations.documents, s.citingDocuments],
    ["hindex", null, "hindex", current.scopus.hindex, s.hindex],
    ["coauthors", null, "coauthors", current.scopus.coauthors, s.coauthors],
  ];
  for (const [label, sub, key, oldV, newV] of map) {
    report(label, oldV, newV);
    setValue("scopus", sub, key, newV);
  }
} catch (e) {
  console.warn(`Scopus skipped: ${e.message}`);
}

if (!changed) {
  console.log("Nothing changed.");
} else if (dryRun) {
  console.log("Dry run: file not written.");
} else {
  const today = new Date().toLocaleDateString("sv-SE"); // YYYY-MM-DD, local time
  text = text.replace(/^updated: .*$/m, `updated: ${today}`);
  await writeFile(FILE, text);
  console.log(`Updated ${path.relative(process.cwd(), FILE)} (${today}).`);
}
