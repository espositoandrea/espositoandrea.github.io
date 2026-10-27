// Two-column essay in the style of the Nature journals: a section tag above a thin rule, a large serif title, the
// authors, a bold summary paragraph, bold sans-serif headings that sit close to their text and far from the text
// before them, "Fig. 1 |" captions, and the cross-post notice at the foot of the first page. The colours are
// those of the site. Variables are set by article.lua and common.lua.
#import "/_pandoc/common.typ": *

#show: base.with(title: $t_title$, author: $t_author$, date: $t_date$)

#let ink = rgb("#1b1917")
#let muted = luma(110)
#let rule-color = luma(205)

#set page(
  paper: "a4",
  fill: none,
  margin: (x: 1.9cm, top: 2.3cm, bottom: 2.2cm),
  columns: 2,
  header: context {
    if counter(page).get().first() > 1 {
      set text(font: sans, size: 7.5pt, fill: muted)
      grid(columns: (1fr, 1fr), align: (left, right), [$short_author$], [$short_title$])
      v(0.5em)
      line(length: 100%, stroke: 0.4pt + rule-color)
    }
  },
  footer: context {
    set text(font: sans, size: 7.5pt, fill: muted)
    line(length: 100%, stroke: 0.4pt + rule-color)
    v(0.5em)
    grid(columns: (1fr, 1fr), align: (left, right), [$site_url$], counter(page).display())
  },
)
#set columns(gutter: 1.4em)
#set text(size: 9.2pt, fill: ink)
#set par(justify: true, leading: 0.6em, spacing: 0.6em, first-line-indent: 1em)

// Headings: a large gap above (they open a section), a small one below (they belong to what follows)
#show heading: set par(first-line-indent: 0pt, justify: false)
#show heading.where(level: 1): it => block(above: 1.9em, below: 0.5em, sticky: true,
  text(font: sans, size: 10pt, weight: "bold", it.body))
#show heading.where(level: 2): it => block(above: 1.4em, below: 0.4em, sticky: true,
  text(font: sans, size: 8.8pt, weight: "bold", it.body))
#show heading.where(level: 3): it => block(above: 1.2em, below: 0.35em, sticky: true,
  text(font: sans, size: 8.8pt, weight: "medium", style: "italic", it.body))

#show quote.where(block: true): set pad(x: 1em)
#show quote.where(block: true): set par(first-line-indent: 0pt)
$if(bib_path)$
// the references are the superscript numbers: footnotes get symbols so that they cannot be mistaken for them
#set footnote(numbering: "*")
$endif$
#show footnote.entry: set text(size: 7.8pt)
#show footnote.entry: set par(first-line-indent: 0pt)
#set list(indent: 0.4em)
#set enum(indent: 0.4em)

// Figures across the column, with a "Fig. 1 |" caption
#set figure(placement: auto, gap: 0.8em)
#show figure: set block(above: 1em, below: 1em)
#show figure.caption: it => {
  set par(first-line-indent: 0pt, justify: false)
  text(font: sans, size: 7.6pt)[
    #text(weight: "bold")[Fig. #context it.counter.display(it.numbering) |] #it.body
  ]
}

// Title block across both columns
#place(top, scope: "parent", float: true, clearance: 1.6em)[
  #set par(first-line-indent: 0pt, justify: false)
  #text(font: sans, size: 8.5pt, weight: "bold", tracking: 0.04em, fill: brand)[$kicker$]
  #v(0.35em)
  #line(length: 100%, stroke: 0.6pt + ink)
  #v(1.1em)
  #block(width: 92%, text(font: display, size: 26pt, weight: "semibold")[#par(leading: 0.4em)[$title$]])
  #v(1em)
  #text(font: sans, size: 9.5pt, weight: "semibold")[$author$]
$if(affiliation)$
  \ #text(font: sans, size: 7.8pt, fill: muted)[$affiliation$]
$endif$
$if(date)$
  \ #text(font: sans, size: 7.8pt, fill: muted)[Published: $date_long$]
$endif$
$if(abstract)$
  #v(1.1em)
  #set par(justify: true)
  #text(size: 9.6pt, weight: "bold")[$abstract$]
$if(tags)$
  #v(0.7em)
  #text(font: sans, size: 7.5pt, fill: muted)[
    #text(weight: "bold")[Keywords:] $for(tags)$$tags$$sep$ · $endfor$
  ]
$endif$
$endif$
  #v(0.9em)
  #line(length: 100%, stroke: 0.4pt + rule-color)
]
$if(notice)$

// Cross-post notice at the foot of the first page
#place(bottom, scope: "parent", float: true, clearance: 1em)[
  #line(length: 100%, stroke: 0.4pt + rule-color)
  #v(0.2em)
  #set text(font: sans, size: 7.2pt, fill: muted)
  #set par(first-line-indent: 0pt, justify: false)
  Copyright © $year$ held by the Author. $notice$
]
$endif$

$body$
$if(bib_path)$

// References, in the style of Nature (numbered in order of citation, superscript in the text)
#set bibliography(title: none, style: "/nature.csl")
#show bibliography: set text(font: sans, size: 7.6pt)
#show bibliography: set par(first-line-indent: 0pt, justify: false)
#bibliography($bib_path$)
$endif$
