// Styling shared by the post PDFs (article.typ, letter.typ, photo.typ). The fonts are those of the site and are
// downloaded by _pandoc/fetch-fonts.sh into _build/fonts (the build runs with --ignore-system-fonts so that it is identical everywhere).

#let serif = ("Source Serif 4",)
#let display = ("Source Serif 4 Display", "Source Serif 4")
#let sans = ("Inter",)
// Brand colour of the site (see _sass/style.scss); the pages themselves are always plain white
#let brand = rgb("#BB0B0B")
#let link-color = brand

// What pandoc writes for a horizontal rule
#let horizontalrule = line(start: (25%, 0%), end: (75%, 0%))
#let horizontalRule = horizontalrule
#let divider = if "divider" in std { std.divider } else { horizontalrule }

// Document defaults: fonts, links, images, PDF metadata
#let base(title: "", author: "", date: none, body) = {
  set document(title: title, author: author, date: date)
  set text(font: serif, lang: "en")
  set smartquote(enabled: true)
  show link: set text(fill: link-color)
  show image: set image(width: 100%)
  show figure.caption: set text(font: sans, size: 0.8em)
  set terms(hanging-indent: 1.5em)
  body
}
