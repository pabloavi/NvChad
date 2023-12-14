#import "@preview/chic-hdr:0.3.0": *

#let project(title: "", authors: (), body) = {
  // Basic properties.
  set document(author: authors, title: title)
  set page(
    numbering: "1",
    number-align: center,
    margin: 2.25cm,
  )
  set text(font: "Linux Libertine", lang: "es", size: 10pt)
  set heading(numbering: "1.1")

  // Set run-in subheadings, starting at level 3.
  show heading: it => {
    if it.level > 2 {
      parbreak()
      text(
        12pt,
        style: "italic",
        weight: "regular",
        it.body + ".",
      )
    } else {
      it
    }
  }

  // Header
  show: chic.with(
    skip: (1,),
    chic-footer(center-side: chic-page-number()),
    chic-header(
      left-side: strong(chic-heading-name()),
      right-side: strong(smallcaps(title)),
    ),
    chic-separator(on: "header", 0.75pt),
    chic-height(1.5cm),
  )

  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title))
  ]

  // Author information.
  pad(top: 0.5em, bottom: 0.5em, x: 2em, grid(
    columns: (1fr,) * calc.min(3, authors.len()),
    gutter: 1em,
    ..authors.map(author => align(center, author)),
  ))

  let indent = 12pt
  // Indent first line of first paragraph.
  set par(justify: true, first-line-indent: indent)
  show "¬": h(indent)

  // Indent lists and enumerations.
  set list(indent: 2 * indent)
  set enum(indent: 2 * indent)

  // Indent outline items.
  set outline(indent: indent)

  body
}
