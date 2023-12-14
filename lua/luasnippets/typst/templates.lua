local enabled = true
local snips, autosnips = {}, {}

local typst = require "luasnippets.typst.utils"

local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt
local expand = require "luasnip.extras.conditions.expand"
local extras = require "luasnip.extras"
local m = extras.m
local n = extras.nonempty
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

snips = {
  s(
    { trig = "init-template", name = "init-template file", dscr = "init-template file" },
    fmt(
      [[
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
        show heading: it =>> {
          if it.level >> 2 {
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
          ..authors.map(author =>> align(center, author)),
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
      ]],
      {},
      { delimiters = "<>" }
    ),
    { condition = typst.in_template, show_condition = typst.in_template }
  ),
  s(
    { trig = "init-subfile", name = "init subfile file", dscr = "init subfile file" },
    fmt(
      [[
      #import "packages.typ": *

      #let content = [
        <>
      ]
      ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),
  s(
    { trig = "init-rel-subfile", name = "init relative subfile file", dscr = "init relative subfile file" },
    fmt(
      [[
      #import "../packages.typ": *

      #let content = [
        <>
      ]
      ]],
      { i(0) },
      { delimiters = "<>" }
    ),
    { condition = typst.in_text * expand.line_begin, show_condition = typst.in_text }
  ),
  s(
    { trig = "init-master", name = "init master file", dscr = "init master file" },
    fmt(
      [[
      #import "template.typ": *
      #import "packages.typ": *
      
      #let title = "<>"
      #show: project.with(title: title, authors: ("Pablo Avilés Mogío",))
      
      #outline()

      <>
      ]],
      { i(1), i(0) },
      { delimiters = "<>" }
    ),
    { condition = typst.in_master * expand.line_begin, show_condition = typst.in_master }
  ),
}

autosnips = {}

if enabled then
  return snips, autosnips
end

return nil, nil
