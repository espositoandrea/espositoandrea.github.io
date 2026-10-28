// Letter after DIN 5008 (form B), with the geometry of the standard: letterhead at the top, address window
// (return line and recipient) 45 mm from the top, folding and punching marks at 105, 148.5 and 210 mm, date line
// at 98.5 mm, the salutation, then the subject below it. The complimentary close and the signature start at the
// centre of the page. The page is plain white. Variables are set by letter.lua and common.lua.
#import "/_pandoc/common.typ": *

#show: base.with(title: $t_title$, author: $t_author$, date: $t_date$)

#let margin-top = 27mm
#let muted = luma(100)

#let letterhead = align(center, {
  text(font: sans, size: 12pt, weight: "semibold", tracking: 0.22em, fill: brand, upper($t_author$))
  v(0.5em)
  text(font: sans, size: 8.5pt, fill: muted, link("$site_url$", "$site_host$"))
})

#set page(
  paper: "a4",
  fill: none,
  margin: (left: 25mm, right: 20mm, top: margin-top, bottom: 25mm),
  // first page: letterhead, address field and folding marks, placed with the page coordinates of the standard
  background: context if counter(page).get().first() == 1 {
    place(top + center, dy: 11mm, letterhead)
    for y in (105mm, 210mm) { place(top + left, dy: y, line(length: 5mm, stroke: 0.3pt + muted)) }
    place(top + left, dy: 148.5mm, line(length: 3mm, stroke: 0.3pt + muted))
$if(address)$
    place(top + left, dx: 25mm, dy: 45mm, block(width: 85mm, height: 45mm)[
      #set par(justify: false, leading: 0.55em, spacing: 0.55em)
      #block(width: 100%, height: 5mm, stroke: (bottom: 0.4pt), inset: (left: 0pt, bottom: 1pt))[
        #align(bottom, text(font: sans, size: 6.5pt, fill: muted)[$author$ · $site_host$])
      ]
      #v(1.5mm)
      $address$
    ])
$endif$
  },
  // the following pages: sender, date and page number
  header: context if counter(page).get().first() > 1 {
    set text(font: sans, size: 8pt, fill: muted)
    grid(columns: (1fr, 1fr), align: (left, right), [$author$$if(date)$ · #$t_date$.display("[day padding:none] [month repr:long] [year]")$endif$], [])
  },
  footer: context if counter(page).final().first() > 1 {
    align(right, text(font: sans, size: 8pt, fill: muted)[Page #counter(page).display() of #counter(page).final().first()])
  },
)
#set text(size: 10.5pt)
#set par(justify: true, leading: 0.66em, spacing: 1.2em, first-line-indent: 1.5em)
#show quote.where(block: true): set pad(x: 1.5em)
#show footnote.entry: set text(size: 8.5pt)
#set figure(placement: auto)
#show image: set image(width: 70%)

// the page up to the date line
#block(height: 98.5mm - margin-top, width: 100%)
$if(date)$
#align(right)[#$t_date$.display("[day padding:none] [month repr:long] [year]")]
$endif$
#v(1.6em)

$if(opening)$
#par(first-line-indent: 0pt)[$opening$]
$endif$
#v(0.4em)
#align(center, text(weight: "bold")[$title$])
#v(0.4em)

$body$

$if(closing)$
#v(1.6em)
#block(breakable: false, pad(left: 80mm, {
  set par(first-line-indent: 0pt, justify: false)
  [$closing$]
  v(2.8em)
  [$author$]
}))
$endif$
