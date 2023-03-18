-- Setup LSP bindings when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		-- Enable completion triggered by <c-x><c-o>
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		local opts = { noremap=true, silent=true }

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		-- buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		buf_set_keymap('n', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
		buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
		buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
		buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

		-- Call require on each of these to make sure they are loaded after attach
		require('lsp_smag')
		require('lsp_signature').on_attach({
			bind = true,
		}, bufnr)

		-- This is used by ui.lua to show the code context using the LSP
		if client.server_capabilities.documentSymbolProvider then
			require('nvim-navic').attach(client, bufnr)
		end
	end
})

return {
	-- Use the LSP to provide tags
	{
		'weilbith/nvim-lsp-smag',
		lazy = true,
		dependencies = {
			'neovim/nvim-lspconfig',
		},
	},

	-- Use the LSP to show function signatures as virtual text
	{
		'ray-x/lsp_signature.nvim',
		lazy = true,
		dependencies = {
			'neovim/nvim-lspconfig',
		},
	},

	-- Code aactions menu
	{
		'weilbith/nvim-code-action-menu',
		lazy = true,
		dependencies = {
			'neovim/nvim-lspconfig',
		},
		cmd = 'CodeActionMenu',
	},

	-- LSP config
	{
		'neovim/nvim-lspconfig',

		config = function()
			require'lspconfig'.clangd.setup{
				filetypes = {"c", "cpp", "objc", "objcpp"},
			}

			-- graphql
			-- Install with: npm install -g graphql-language-service-cli
			require'lspconfig'.graphql.setup{}
			require'lspconfig'.gopls.setup{ }

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					show_header = true,
					source = 'any',
					border = 'rounded',
					focusable = false,
				}
			})
		end
	},

	{

		'jose-elias-alvarez/null-ls.nvim',

		dependencies = {
			'lewis6991/gitsigns.nvim',
		},

		config = function()
			null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.code_actions.gitsigns,
					null_ls.builtins.code_actions.gomodifytags,
				}
			})
		end
	},
}
