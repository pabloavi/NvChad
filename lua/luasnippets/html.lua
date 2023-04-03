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

snips = {}

autosnips = {
  s(
    { trig = "card([%d])", name = "jeckyll card item", dscr = "jeckyll website card item", regTrig = true },
    fmt(
      [[
            {% if site.card_[] != false %}
            <div class="item item-[] col-lg-4 col-6">
                <div class="item-inner">
                    <div class="icon-holder">
                        <i class="icon fa fa-[]"></i>
                    </div><!--//icon-holder-->
                    <h3 class="title">{{ card_[]_title }}</h3>
                    <p class="intro">{{ card_[]_intro }}</p>
                    <a class="link" href="{{ card_[]_link | prepend: site.baseurl }}"><span></span></a>
                </div><!--//item-inner-->
            </div><!--//item-->
            {% endif %}
            []
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        c(1, { t "green", t "blue", t "orange", t "red", t "pink", t "purple" }),
        i(2, "icon"),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),

  s(
    {
      trig = "precard([%d])",
      name = "jeckyll card item",
      dscr = "jeckyll website card item",
      regTrig = true,
      priority = 200,
    },
    fmt(
      [[
      {% if site.card_[]_title %}
          {% assign card_[]_title = site.card_[]_title %}                    
      {% else %}
          {% assign card_[]_title = '[]' %}
      {% endif %}
      
      {% if site.card_[]_intro %}
          {% assign card_[]_intro = site.card_[]_intro %}                    
      {% else %}
          {% assign card_[]_intro = '[]' %}
      {% endif %}
      
      {% if site.card_[]_link %}
          {% assign card_[]_link = site.card_[]_link %}                    
      {% else %}
          {% assign card_[]_link = '/[]' %}
      {% endif %}            
      []
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        i(1, "titulo"),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        i(2, "intro"),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        f(function(_, snip)
          return snip.captures[1]
        end, {}),
        i(3, "link"),
        i(0),
      },
      { delimiters = "[]" }
    )
  ),
}

return snips, autosnips
