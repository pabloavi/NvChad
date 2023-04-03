local snips, autosnips = {}, {}

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
    { trig = "doc", name = "jekyll doc", dscr = "jekyll doc title, intro..." },
    fmt(
      [[
      ---
      title: <>
      excerpt: <>.
      date: <>
      icon<>
      color: <>
      sections:
        - /<>
      <>
      ---
      ]],
      {
        i(1, "Título"),
        i(2, "Descripción"),
        i(3),
        i(4),
        c(5, { t "green", t "blue", t "orange", t "red", t "pink", t "purple" }),
        i(6),
        i(0),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "icon", name = "normal icon", dscr = "normal icon" },
    fmt(
      [[
    icon: <>
      name: <>
    ]],
      { i(1), i(2) },
      { delimiters = "<>" }
    )
  ),

  -- iconfa
  s(
    { trig = "iconfa", name = "fontawesome icon", dscr = "fontawesome icon" },
    fmt(
      [[
      icon:
        type: fa
        name: fa-<>
      ]],
      { i(1) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "sec", name = "jekyll section", dscr = "jekyll section" },
    fmt(
      [[
      ---
      title: <>
      sections:
        - <>
      ---
      
      ### <>
      
      <>
      ]],
      {
        i(1),
        i(2),
        rep(2),
        i(0),
      },
      { delimiters = "<>" }
    )
  ),

  -- tab
  s(
    { trig = "tab", name = "jekyll tab", dscr = "jekyll tab" },
    fmt(
      [[
      *&nbsp;*<>
      ]],
      { i(0) },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "faicon", name = "jekyll fa icon", dscr = "jekyll font awesome icon" },
    fmt(
      [[
      {: .fa .fa-<>}<>
      ]],
      {
        i(1),
        i(0),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    { trig = "img", name = "jekyll img", dscr = "jekyll img" },
    fmt(
      [[
      <div class="section-block"><div class="jumbotron text-center">
       
      # []
      
      []
      
      </div></div>
      []
      ]],
      {
        i(1, "Título"),
        i(2, "Texto"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  s(
    { trig = "note", name = "jekyll note", dscr = "jekyll note" },
    fmt(
      [[
      <div class="callout-block callout-info"><div class="icon-holder">*&nbsp;*{: .fa .fa-info-circle}
      </div><div class="content">
      {: .callout-title}
      #### Nota:
      
      []

      </div></div>
      []
      ]],
      {
        i(1, "Texto"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  -- bug
  s(
    { trig = "bug", name = "jekyll bug", dscr = "jekyll bug" },
    fmt(
      [[
      <div class="callout-block callout-warning"><div class="icon-holder">*&nbsp;*{: .fa .fa-bug}
      </div><div class="content">
      {: .callout-title}
      #### Bug:
      
      []

      </div></div>
      []
      ]],
      {
        i(1, "Texto"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  -- tips
  s(
    { trig = "tip", name = "jekyll tips", dscr = "jekyll tips" },
    fmt(
      [[
      <div class="callout-block callout-success"><div class="icon-holder">*&nbsp;*{: .fa .fa-thumbs-up}
      </div><div class="content">
      {: .callout-title}
      #### Consejo:
      
      []

      </div></div>
      []
      ]],
      {
        i(1, "Texto"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  -- danger
  s(
    { trig = "danger", name = "jekyll danger", dscr = "jekyll danger" },
    fmt(
      [[
      <div class="callout-block callout-danger"><div class="icon-holder">*&nbsp;*{: .fa .fa-exclamation-triangle}
      </div><div class="content">
      {: .callout-title}
      #### Peligro:
      
      []

      </div></div>
      []
      ]],
      {
        i(1, "Texto"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  s(
    { trig = "table", name = "jekyll table", dscr = "jekyll table" },
    fmt(
      [[
      <div class="table-responsive">
      
      {: .table}
      | # | First Name | Last Name | Username
      |-
      | 1 | Mark       | Otto      | @mdo
      | 2 | Jacob      | Thornton  | @fat
      | 3 | Larry      | the Bird  | @twitter

</div>
      ]],
      {},
      { delimiters = "[]" }
    )
  ),

  -- -- promo
  -- s(
  --   { trig = "promo", name = "jekyll promo", dscr = "jekyll promo" },
  --   fmt(
  --     [[
  --     promo:
  --       title: "*&nbsp;*{: .fa .fa-heart} [AppKit - Bootstrap Angular Admin Theme for Developers](https://wrapbootstrap.com/theme/admin-appkit-admin-theme-angularjs-WB051SCJ1?ref=3wm)"
  --       link: https://wrapbootstrap.com/theme/admin-appkit-admin-theme-angularjs-WB051SCJ1?ref=3wm
  --       image:
  --         alt: AppKit Theme
  --         link: assets/images/demo/appkit-dashboard-3-thumb.jpg
  --         icon:
  --           type: fa
  --           name: fa-heart pink
  --       content:
  --         title: "**Love this free documentation theme?**"
  --         desc: |
  --           Check out AppKit - an Angular admin theme I created with my developer friend [Tom Najdek](https://twitter.com/tnajdek)
  --           for developers. AppKit uses modern front-end technologies and is packed with useful components and widgets to speed up your app development.
  --
  --           **[Tip for developers]:**{: .highlight}
  --           If your project is Open Source, you can use this area to promote your other projects or hold third party adverts like Bootstrap and FontAwesome do!
  --
  --           [View Demo](https://wrapbootstrap.com/theme/admin-appkit-admin-theme-angularjs-WB051SCJ1?ref=3wm){: .btn .btn-cta}
  --
  --           {: .author}
  --           [Xiaoying Riley](http://themes.3rdwavemedia.com)
  --     ]],
  --     {
  --       i(1),
  --       i(2),
  --       i(3),
  --       i(4, "fa"),
  --       i(5, "fa-github"),
  --       c(6, { t "green", t "blue", t "orange", t "red", t "pink", t "purple" }),
  --       i(7),
  --       rep(2),
  --       i(0),
  --     },
  --     { delimiters = "<>" }
  --   )
  -- ),
}

autosnips = {}

return snips, autosnips
