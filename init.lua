-- Improve startup time
require("impatient")

require("user.plugins")
require("user.lsp")
require("user.options")
require("user.keybinds")

-- Configure colorscheme at the end of config execution to override styling conflicts
vim.g.edge_style = "neon"
vim.g.edge_diagnostic_virtual_text = "colored"
vim.cmd([[ colorscheme edge ]])
