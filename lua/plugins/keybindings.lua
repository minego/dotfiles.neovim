return {
	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")
		wk.setup {}

		-- Open a terminal with ^Z
		wk.register({ ["<c-z>"] = { '<cmd>top split | terminal<CR><C-L>', "Open a Terminal" } }, { mode = "n", silent = true })

		-- make
		wk.register({
			["<leader>m"] = {
				name	= "make",

				c		= { "<cmd>make clean<CR>",				"make clean"			},
				C		= { "<cmd>make clean<CR>",				"make clean"			},
				a		= { "<cmd>make all<CR>",				"make all"				},
				A		= { "<cmd>make clean all<CR>",			"make clean all"		},
				i		= { "<cmd>make all install<CR>",		"make all install"		},
				I		= { "<cmd>make clean all install<CR>",	"make clean all install"},
				t		= { "<cmd>make all test<CR>",			"make all test"			},
				T		= { "<cmd>make clean all test<CR>",		"make clean all test"	},
			},
		},  { mode = "n" })

		-- Ignore F1 because it is too close to the escape key
		wk.register({ ["<F1>"] = { "<cmd><CR>", "Ignored" } }, { mode = "n", silent = true })
		wk.register({ ["<F1>"] = { "<cmd><CR>", "Ignored" } }, { mode = "i", silent = true })

		-- Change directory
		wk.register({
			["<leader>"] = {
				name	= "Change current directory",

				["cd"]	= { "<cmd>tcd %:p:h<CR>",				"Switch the current directory to that of the current file only for the current tab" },
				["lcd"]	= { "<cmd>lcd %:p:h<CR>",				"Switch the current directory to that of the current file only for the current window" },
			}
		}, { mode = "n" })

		-- Quickfix
		wk.register({
			["]q"]		= { "<cmd>cnext<cr>",					"Jump to next warning or error" },
			["[q"]		= { "<cmd>cprev<cr>",					"Jump to prev warning or error" },
		}, { mode = "n", silent = true })

		wk.register({ ["<leader>w"]	= { "<cmd>wincmd w<CR>", "Select next window" } }, { mode = "n", silent = true })
		wk.register({ ["<leader>W"]	= { "<cmd>wincmd W<CR>", "Select prev window" } }, { mode = "n", silent = true })

		-- Split helpers
		wk.register({ ["<leader>s"]	= { "<cmd>wincmd s<CR>", ":split"  } }, { mode = "n", silent = true })
		wk.register({ ["<leader>v"]	= { "<cmd>wincmd v<CR>", ":vsplit" } }, { mode = "n", silent = true })

		wk.register({ ["<leader>S"]	= { ":split  <C-R>=expand('%:p:h').'/'<CR>", ":split ..."	} }, { mode = "n", silent = false })
		wk.register({ ["<leader>V"]	= { ":vsplit <C-R>=expand('%:p:h').'/'<CR>", ":vsplit ..."	} }, { mode = "n", silent = false })
		wk.register({ ["<leader>e"]	= { ":edit   <C-R>=expand('%:p:h').'/'<CR>", ":edit ..."	} }, { mode = "n", silent = false })

		-- Terminal
		wk.register({ ["<esc><esc>"]= { "<c-\\><c-n>",			"Escape with double escape"	} }, { mode = "t", silent = false })
		wk.register({ ["<c-w>"]     = { "<c-\\><c-n><c-w>",		"Treat <c-w> like any other window"	} }, { mode = "t", silent = false })
	end
}


