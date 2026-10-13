#!/usr/bin/env node
// Generates the Open Graph images (1200x630 PNG) used when sharing the site's pages:
//   assets/images/og/posts/<post file name>.png  one per post in _posts/
//   assets/images/og/default.png                 for pages without an image of their own
// The layouts pick them up when they exist (see _includes/og-image.html and _includes/seo.html),
// so run this before `jekyll build` (`npm run og-images`; the deploy workflow does it).
// Front matter: `og_image`, or else the featured `image`, replaces the generated image of a post (none is generated for it); `og_title` and `og_kicker`
// override the title and the label above it.

import { readFile, writeFile, mkdir, readdir } from "node:fs/promises";
import { createRequire } from "node:module";
import path from "node:path";
import { fileURLToPath } from "node:url";
import satori from "satori";
import { Resvg } from "@resvg/resvg-js";
import { load as parseYaml } from "js-yaml";

const require = createRequire(import.meta.url);
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const outDir = path.join(root, "assets/images/og");

const WIDTH = 1200;
const HEIGHT = 630;
const BRAND = "#BB0B0B";
const INK = "#1a1a1a";
const MUTED = "#5c5c5c";
const PAPER = "#fbfaf8";

const fontFile = (pkg, file) => readFile(require.resolve(`@fontsource/${pkg}/files/${file}`));
const fonts = [
    { name: "Serif", weight: 600, data: await fontFile("source-serif-4", "source-serif-4-latin-600-normal.woff") },
    { name: "Serif", weight: 600, data: await fontFile("source-serif-4", "source-serif-4-latin-ext-600-normal.woff") },
    { name: "Sans", weight: 400, data: await fontFile("inter", "inter-latin-400-normal.woff") },
    { name: "Sans", weight: 400, data: await fontFile("inter", "inter-latin-ext-400-normal.woff") },
    { name: "Sans", weight: 700, data: await fontFile("inter", "inter-latin-700-normal.woff") },
    { name: "Sans", weight: 700, data: await fontFile("inter", "inter-latin-ext-700-normal.woff") },
].map((font) => ({ ...font, style: "normal" }));

const config = parseYaml(await readFile(path.join(root, "_config.yml"), "utf8"));
const curriculum = parseYaml(await readFile(path.join(root, "_data/curriculum.yml"), "utf8"));
const author = config.author;
const domain = new URL(config.url).host;
const avatar = `data:image/jpeg;base64,${(await readFile(path.join(root, author.picture))).toString("base64")}`;

// Minimal element factory in the shape satori expects (instead of JSX).
const h = (type, style, ...children) => ({
    type,
    props: { style: { display: "flex", ...style }, children: children.flat().filter((c) => c !== null && c !== undefined && c !== false) },
});
const img = (src, style) => ({ type: "img", props: { src, style } });

function titleSize(title) {
    if (title.length <= 40) return 78;
    if (title.length <= 70) return 66;
    if (title.length <= 100) return 56;
    return 46;
}

// Smart quotes and dashes, as Jekyll's smartify does on the pages.
const smartify = (text) =>
    text
        .replace(/---/g, "—")
        .replace(/--/g, "–")
        .replace(/(^|[\s(\[])'/g, "$1‘")
        .replace(/'/g, "’")
        .replace(/(^|[\s(\[])"/g, "$1“")
        .replace(/"/g, "”");

function card({ kicker, title, footer }) {
    return h(
        "div",
        { width: WIDTH, height: HEIGHT, backgroundColor: PAPER, fontFamily: "Sans", color: INK },
        h("div", { width: 24, height: "100%", backgroundColor: BRAND }),
        h(
            "div",
            { flexDirection: "column", justifyContent: "space-between", flexGrow: 1, padding: "64px 72px 56px 64px" },
            h(
                "div",
                { flexDirection: "column" },
                kicker &&
                    h("div", { fontSize: 26, fontWeight: 700, letterSpacing: 3, textTransform: "uppercase", color: BRAND, marginBottom: 28 }, kicker),
                h("div", { fontFamily: "Serif", fontWeight: 600, fontSize: titleSize(title), lineHeight: 1.12 }, smartify(title)),
            ),
            h(
                "div",
                { alignItems: "center", justifyContent: "space-between", borderTop: "2px solid #e4e1dc", paddingTop: 32 },
                h(
                    "div",
                    { alignItems: "center" },
                    img(avatar, { width: 76, height: 76, borderRadius: 38, marginRight: 24 }),
                    h(
                        "div",
                        { flexDirection: "column" },
                        h("div", { fontSize: 30, fontWeight: 700 }, author.name),
                        footer && h("div", { fontSize: 24, color: MUTED, marginTop: 4 }, footer),
                    ),
                ),
                h("div", { fontSize: 24, color: MUTED }, domain),
            ),
        ),
    );
}

async function render(element, file) {
    const svg = await satori(element, { width: WIDTH, height: HEIGHT, fonts });
    const png = new Resvg(svg, { fitTo: { mode: "width", value: WIDTH } }).render().asPng();
    await mkdir(path.dirname(file), { recursive: true });
    await writeFile(file, png);
    console.log(`og-images: ${path.relative(root, file)}`);
}

function parsePost(source) {
    const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
    return match ? { data: parseYaml(match[1]) ?? {}, body: match[2] } : { data: {}, body: source };
}

const dateFormat = new Intl.DateTimeFormat("en-US", { year: "numeric", month: "long", day: "numeric", timeZone: "UTC" });

const postsDir = path.join(root, "_posts");
for (const name of (await readdir(postsDir)).filter((f) => /\.(md|markdown)$/.test(f)).sort()) {
    const { data, body } = parsePost(await readFile(path.join(postsDir, name), "utf8"));
    if (data.og_image || data.image) continue;

    const slug = name.replace(/\.(md|markdown)$/, "");
    const date = data.date ? new Date(data.date) : new Date(`${slug.slice(0, 10)}T00:00:00Z`);
    const categories = [data.category, data.categories].flat().filter(Boolean);
    // Same estimate as the post layout: 200 words per minute, rounded up.
    const minutes = Math.floor(body.split(/\s+/).filter(Boolean).length / 200) + 1;

    await render(
        card({
            kicker: data.og_kicker ?? (categories.length ? categories.join(" · ") : "Blog"),
            title: String(data.og_title ?? data.title ?? slug),
            footer: `${dateFormat.format(date)} · ${minutes} min read`,
        }),
        path.join(outDir, "posts", `${slug}.png`),
    );
}

const affiliation = curriculum.affiliation?.institution?.name;
const position = curriculum.position ?? author.jobTitle;
await render(
    card({
        kicker: "Research · Publications · Blog",
        title: (curriculum.interests ?? []).slice(0, 3).join(", ") || config.description,
        footer: [author.honorificSuffix, affiliation ? `${position} at ${affiliation}` : position].filter(Boolean).join(" · "),
    }),
    path.join(outDir, "default.png"),
);
