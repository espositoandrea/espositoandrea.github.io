// Two-column essay in the style of the Nature journals: a section tag above a thin rule, a large serif title, the
// authors, a bold summary paragraph, bold sans-serif headings that sit close to their text and far from the text
// before them, "Fig. 1 |" captions, and the cross-post notice at the foot of the first page. The colours are
// those of the site. Variables are set by article.lua and common.lua.
#import "/_pandoc/common.typ": *

#show: base.with(title: $t_title$, author: $t_author$, date: $t_date$)

#let ink = rgb("#1b1917")
#let muted = luma(110)
#let rule-color = luma(205)

// Typst does not balance the columns of the last page: the left column is filled first. Balancing it takes a spacer
// across both columns at the bottom of the last page, anchored at the end of the text, whose height is derived
// from the previous layout pass: the end of the text (in which column, at what height) gives the amount of text
// on the page, and the columns are given half of it (plus a line). The layout settles in two or three passes.
#let top-margin = 2.3cm
#let balance-end = context {
  let ends = query(<balance-end>)
  let spacers = query(<balance-spacer>)
  let height = 0pt
  if ends.len() > 0 and spacers.len() > 0 {
    let end = ends.first().location()
    let spacer = spacers.first()
    let spacer-position = spacer.location().position()
    if end.page() > 1 and end.page() == spacer.location().page() {
      let region-bottom = spacer-position.y + spacer.value + 1pt
      let used = end.position().y - top-margin
      let total = if end.position().x > page.width / 2 { spacer-position.y - top-margin + used } else { used }
      let wanted = calc.max(0pt, region-bottom - top-margin - total / 2 - 1.8em.to-absolute())
      // columns end on line boundaries, so the estimate jumps by a line when the spacer changes: only follow it
      // when the correction is larger than that, which lets the layout settle
      height = if calc.abs(wanted - spacer.value) < 1.6em.to-absolute() { spacer.value } else { wanted }
    }
  }
  // the spacer takes no room in the flow, and the marker none either (a zero-height block: unlike a paragraph, it
  // cannot push a page of its own when the last page is full)
  place(bottom, scope: "parent", float: true, clearance: 0pt, block(height: height + 1pt, width: 100%)[#metadata(height) <balance-spacer>])
  block(width: 0pt, height: 0pt, above: 0pt, below: 0pt)[#metadata(none) <balance-end>]
}

#set page(
  paper: "a4",
  fill: none,
  margin: (x: 1.9cm, top: top-margin, bottom: 2.2cm),
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

// Block quotes, with their credit (the "— Name" last line of the quote) right-aligned under them
#show quote.where(block: true): it => block(
  width: 100%, above: 1.2em, below: 1.2em, inset: (left: 0.9em, y: 0.1em), stroke: (left: 1.5pt + brand),
  {
    set par(first-line-indent: 0pt)
    text(style: "italic", it.body)
    if it.attribution != none {
      v(0.5em, weak: true)
      align(right, text(font: sans, size: 7.8pt, style: "normal", fill: muted)[— #it.attribution])
    }
  },
)
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

#balance-end
