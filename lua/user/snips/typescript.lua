local ls = require("luasnip")
local snippet_collection = require("luasnip.session.snippet_collection")

local i = ls.insert_node
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt

snippet_collection.clear_snippets("typescript")
ls.add_snippets("typescript", {
	s("cl", fmt("console.log({});", i(1))),
})
