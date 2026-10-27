// Magazine-style photo essay (A4 portrait). Variables are set by photo.lua and common.lua.
#import "/_pandoc/common.typ": *

#let photos = $photos_typst$

#show: base.with(title: $t_title$, author: $t_author$, date: $t_date$)

#let margin-x = 2.8cm
#let margin-bottom = 2.6cm
#let accent = link-color
#let ink = luma(20)
#let muted = luma(105)

// "Title · March 18, 2026 · Frankfurt, Germany" and, under it, the camera settings
#let caption-of(p, dark: false) = {
  set text(font: sans, size: 7.5pt, fill: if dark { luma(190) } else { muted })
  set par(justify: false, leading: 0.55em, first-line-indent: 0pt)
  let line = (p.date, p.location).filter(s => s != "").join(" · ")
  if p.title != "" {
    text(weight: "semibold", fill: if dark { white } else { ink })[#p.title]
    if line != "" [ #h(0.4em) #line]
  } else [#line]
  if p.caption != "" [ \ #p.caption]
  if p.exif != "" [ \ #text(size: 7pt)[#p.exif]]
}

// A photo of the story, exactly where the text places it. Photos are as wide as the text plus a little bleed
// ("wide", the default; "full": to the edges of the page; "text": as wide as the text). When the page has not
// enough room left for the photo, it is scaled down to fill what is left (down to 50%); if even that is too
// little, it starts the next page. Tall photos are limited in height.
#let photo(n, layout: "") = {
  let p = photos.at(n - 1)
  let anchor = [#metadata(p.id)#label("photo-" + p.id)]
  context {
    let size = measure(image(p.src, width: 100pt))
    let ratio = size.width / size.height
    let bleed = if layout == "full" { margin-x } else if layout == "text" { 0pt } else { 0.5cm }
    let caption-height = 1.9cm
    let above = 1.4em.to-absolute()
    let natural-width = calc.min(page.width - 2 * margin-x + 2 * bleed, 9.5cm * ratio)
    let natural-height = natural-width / ratio + caption-height
    let room = page.height - margin-bottom - here().position().y - above - 0.4cm
    let width = natural-width
    if room < natural-height and room >= 0.5 * natural-height {
      width = (room - caption-height) * ratio
    }
    block(breakable: false, above: above, below: 1.8em, width: 100%, align(center, block(width: width)[
      #anchor
      #image(p.src, alt: p.alt, width: 100%)
      #v(0.6em)
      #align(left, caption-of(p))
    ]))
  }
}

// The first paragraph of the text
#let lead(body) = {
  set text(size: 1.2em)
  set par(leading: 0.8em)
  body
}

#set page(
  paper: "a4",
  fill: none,
  margin: (x: margin-x, top: 2.8cm, bottom: margin-bottom),
  footer: context {
    set text(font: sans, size: 7.5pt, fill: muted, tracking: 0.1em)
    grid(columns: (1fr, 1fr), align: (left, right), upper[$short_title$], counter(page).display())
  },
)
#set text(size: 10pt, fill: ink)
#set par(justify: true, leading: 0.7em, spacing: 1em, first-line-indent: 0pt)
#show heading.where(level: 1): it => block(sticky: true, above: 2.4em, below: 1em)[
  #text(font: display, size: 17pt, weight: "semibold")[#it.body]
]
#show footnote.entry: set text(font: sans, size: 7.5pt, fill: muted)
#show quote.where(block: true): set pad(x: 1.5em)

// Opening of the story: the cover photo bleeds off the top and the sides of the first page, then the title block
#let opener-height = 11.5cm
$if(t_cover)$
#place(top + left, dx: -margin-x, dy: -2.8cm, image($t_cover$, width: 100% + 2 * margin-x, height: opener-height, fit: "cover"))
#v(opener-height - 2.8cm + 1.4cm)
$else$
#v(0.5cm)
$endif$
#{
  set par(justify: false, first-line-indent: 0pt)
  text(font: sans, size: 8pt, weight: "semibold", tracking: 0.2em, fill: accent)[#upper[$kicker$]]
  v(0.6em)
  block(width: 95%, text(font: display, size: 34pt, weight: "semibold")[#par(leading: 0.45em)[$title$]])
$if(excerpt)$
  v(0.9em)
  block(width: 92%, text(size: 12.5pt, style: "italic", fill: luma(70))[$excerpt$])
$endif$
  v(1em)
  text(font: sans, size: 8pt, tracking: 0.08em, fill: muted)[#upper[By $author$] #h(0.5em) · #h(0.5em) #upper[$date_long$]]
  v(0.8em)
  line(length: 100%, stroke: 0.4pt + luma(200))
  v(1.2em)
}

$body$

// Contact sheet and colophon
#heading(level: 1, numbering: none)[Photographs]
#grid(
  columns: (1fr,) * 3,
  column-gutter: 0.6cm,
  row-gutter: 0.9cm,
  ..photos.enumerate().map(((i, p)) => {
    set par(justify: false, leading: 0.5em, spacing: 0.5em)
    image(p.src, alt: p.alt, width: 100%, height: 2.9cm, fit: "cover")
    v(0.35em)
    text(font: sans, size: 7pt, fill: muted)[
      #text(fill: accent, weight: "semibold")[#if i + 1 < 10 [0]#(i + 1)] #h(0.2em)
      #text(weight: "semibold", fill: ink)[#p.title] \
      #p.location
      #context {
        let hits = query(label("photo-" + p.id))
        if hits.len() > 0 {
          let at = hits.first().location()
          [ · #link(at)[p. #counter(page).at(at).first()]]
        }
      }
    ]
  })
)

#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(190))
#v(0.4em)
#set text(font: sans, size: 7.5pt, fill: muted)
#set par(justify: false, leading: 0.6em)
$if(canonical_url)$
This story was originally published on $if(canonical_site_name)$#text(weight: "semibold")[$canonical_site_name$]. $endif$
#link($t_canonical$)[Read the original]. \
$endif$
Text and photographs © $year$ $author$. Find more at #link("$site_url$")[$site_url$].
