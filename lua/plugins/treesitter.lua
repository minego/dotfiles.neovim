return {
	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdateSync",

		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},

		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = {
					"c", "cpp", "make", "llvm", "go",
					"html", "css", "javascript", "json", "typescript", "tsx",
					"todotxt", "query",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (for "all")
				-- ignore_install = { "javascript" },

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = false
				},
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = 'o',
						toggle_hl_groups = 'i',
						toggle_injected_languages = 't',
						toggle_anonymous_nodes = 'a',
						toggle_language_display = 'I',
						focus_language = 'f',
						unfocus_language = 'F',
						update = 'R',
						goto_node = '<cr>',
						show_help = '?',
					},
				},

				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist

						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@function.outer",
							-- ["]]"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@function.outer",
							-- ["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@function.outer",
							-- ["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@function.outer",
							-- ["[]"] = "@class.outer",
						},
					},
				},
			}

			local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		end
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		config = 'vim.cmd[[ hi link TreesitterContext StatusLine ]]'
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
}
