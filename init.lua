-- Improve startup time
require("impatient")

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("user.plugins")
require("user.lsp")
require("user.options")
require("user.keybinds")

-- Configure colorscheme at the end of config execution to override styling conflicts
vim.g.edge_style = "neon"
vim.g.edge_diagnostic_virtual_text = "colored"
vim.cmd([[ colorscheme edge ]])
