local servers = {
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"html",
	"pyright",
	-- "rust_analyzer", -- It's being initialized by rust-tools
	"sumneko_lua",
	-- "tailwindcss",
	"tsserver",
}

local has_formatter = { "gopls", "html", "rust_analyzer", "sumneko_lua" }

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.diagnostic.config({
		virtual_text = false, -- Disable virtual_text since it's redundant due to lsp_lines.
		update_in_insert = true,
	})

	local opts = { buffer = bufnr }
	vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<Leader>i", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<Leader>`", vim.lsp.buf.code_action, opts)

	for _, value in pairs(has_formatter) do
		if client.name == value then
			should_format = false
		end
	end
	if not should_format then
		client.server_capabilities.document_formatting = false -- nvim 0.7 and earlier
		client.server_capabilities.documentFormattingProvider = false -- nvim 0.8 and later
	end
end

local nvim_lsp = require("lspconfig")
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	})
end

-- Dedicated rust-tools rust_analyzer init
require("rust-tools").setup({
	server = { on_attach = on_attach },
	tools = { inlay_hints = { show_variable_name = true } },
})

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
	command = "lua vim.lsp.buf.format()",
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
