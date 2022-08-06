local servers = {
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"html",
	"pyright",
	"rust_analyzer",
	"sumneko_lua",
	"tailwindcss",
	"tsserver",
}
local has_formatter = { "gopls", "html", "rust_analyzer", "sumneko_lua", "tsserver" }
for _, name in pairs(servers) do
	local found, server = require("nvim-lsp-installer").get_server(name)
	if found and not server:is_installed() then
		print("Installing " .. name)
		server:install()
	end
end
local setup_server = {
	sumneko_lua = function(opts)
		opts.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
	end,
}
require("nvim-lsp-installer").on_server_ready(function(server)
	local opts = {
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = false,
			})
			local opts = { buffer = bufnr }
			vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
			local should_format = true
			for _, value in pairs(has_formatter) do
				if client.name == value then
					should_format = false
				end
			end
			if not should_format then
				client.resolved_capabilities.document_formatting = false
			end
		end,
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
	if setup_server[server.name] then
		setup_server[server.name](opts)
	end
	server:setup(opts)
end)

vim.g.completeopt = "menu,menuone,noselect,noinsert"

local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = { { name = "nvim_lsp" }, { name = "vsnip" } },
})

-- Autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	command = "lua vim.lsp.buf.formatting_sync(nil, 1000)",
	pattern = "*.cpp,*.css,*.go,*.h,*.html,*.js,*.json,*.jsx,*.lua,*.md,*.py,*.rs,*.ts,*.tsx,*.yaml",
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
	},
})
