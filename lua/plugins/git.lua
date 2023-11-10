return {
	{
		'lewis6991/gitsigns.nvim',

		opts = {
			signs = {
				add				= { text = '│' },
				change			= { text = '│' },
				delete			= { text = '_' },
				topdelete		= { text = '‾' },
				changedelete	= { text = '~' },
				untracked		= { text = '┆' },
			},
			signcolumn			= true,
			numhl				= false,
			linehl				= false,
			word_diff			= false,
			watch_gitdir = {
				interval		= 1000,
				follow_files	= true
			},
			attach_to_untracked	= true,
			current_line_blame	= false,

			sign_priority		= 6,
			update_debounce		= 100,
			status_formatter	= nil, -- Use default
			max_file_length		= 80000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border			= 'single',
				style			= 'minimal',
				relative		= 'cursor',
				row				= 0,
				col				= 1
			},
			yadm = {
				enable			= false
			},
		}
	},
	{
		'tpope/vim-fugitive',

		-- I probably always want git
		lazy = false,

		dependencies = {
			'folke/which-key.nvim',
			'nvim-telescope/telescope.nvim',
			'shumphrey/fugitive-gitlab.vim',
			'lewis6991/gitsigns.nvim',
		},

		keys = {
			{ "<leader>g", nil, desc = "Git mappings" },
		},

		config = function()
			local wk = require("which-key")

			-- Git bindings using <leader>g in a group
			wk.register({
				["<leader>g"] = {
					name = "Git",

					s = { ":G<CR>",				"git status"			},
					S = { ":Telescope git_status<CR>",
												"git status (telescope)"},
					p = { ":G pull<CR>",		"git pull"				},
					P = { ":G push<CR>",		"git push"				},
					d = { ":Gdiffsplit<CR>",	"git diff (split)"		},
					b = { ":G blame<CR>",		"git blame"				},
					l = { ":Gclog<CR>",			"git log"				},
					r = { ":Gread<CR>",			"git checkout --"		},
					a = { ":Gwrite<CR>",		"git add"				},
					B = { ":GBrowse<CR>",		"Open in browser"		},
					h = { ":Telescope git_bcommits<CR>",
												"git commit history for this buffer"},
					H = { ":Telescope git_commits<CR>",
												"git commit history for all files"},
				}
			}, { mode = "n", silent = true })
		end
	},
	{
		'NeogitOrg/neogit',

		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"nvim-telescope/telescope.nvim", -- optional
			-- "sindrets/diffview.nvim",        -- optional
			-- "ibhagwan/fzf-lua",              -- optional
		},
		config = true
	},
}
