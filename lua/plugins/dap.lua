return {
	-- DAP - Debugger Adapter Protocol
	{
		'mfussenegger/nvim-dap',

		-- I don't need or use this heavily on windows, so disable for now
		enabled = function()
			return vim.fn.has('unix')
		end,

		dependencies = {
			'folke/which-key.nvim',
			'theHamsta/nvim-dap-virtual-text',
			'nvim-telescope/telescope-dap.nvim',
		},

		config = function()
			local wk	= require("which-key")
			local dap	= require('dap')

			dap.adapters.lldb = {
				type	= 'executable',
				command	= 'lldb-vscode',
				name	= "lldb"
			}
			dap.adapters.c   = dap.adapters.lldb
			dap.adapters.cpp = dap.adapters.lldb

			dap.configurations.c = {
				{
					name = 'Attach to process',
					type = 'c',
					request = 'attach',
					pid = require('dap.utils').pick_process,
					args = {}
				},
				{
					name = 'Launch',
					type = 'c',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = {},
					runInTerminal = false,
				},
			}

			-- An example .vscode/launch.json
			-- {
			-- 	"version": "0.2.0",
			-- 	"configurations": [{
			-- 		"name": "checkgrant",
			-- 
			-- 		"type": "c",
			-- 		"request": "launch",
			-- 		"program": "${input:bin}",
			-- 		"args": [ "checkgrant" ]
			-- 	}],
			-- 	"inputs": [{
			-- 		"id": "bin",
			-- 		"type": "promptString",
			-- 		"description": "Program to run: ",
			-- 		"default": "../../bin/pkcs11config"
			-- 	} ]
			-- }

			-- This can be used for cpp and rust as well
			dap.configurations.cpp	= dap.configurations.c
			dap.configurations.objc	= dap.configurations.c
			dap.configurations.rust	= dap.configurations.c

			-- DAP bindings to try to match other debuggers

			-- <F5> Start/Continue
			local function f5()
				require'dap.ext.vscode'.load_launchjs()
				require'dap'.continue()
			end

			-- <S-F5> Terminate
			local function f17()
				require'dap'.terminate()
				require'dap'.close()
				require'nvim-dap-virtual-text'.refresh()

				require('dap').repl.close()	
				require('dapui').close()
			end

			-- <F9> Toggle breakpoint
			local function f9()
				require'dap'.toggle_breakpoint()
			end

			-- <F10> Step over
			local function f10()
				require'dap'.step_over()
			end

			-- <F11> Step into
			local function f11()
				require'dap'.step_into()
			end

			-- <S-F11> / <S-F12> Step out
			local function f12()
				require'dap'.step_out()
			end


			wk.register({ ["<F5>" ] = { f5, "Debugger: Continue"			} }, { mode = "n", silent = true })
			wk.register({ ["<F5>" ] = { f5, "Debugger: Continue"			} }, { mode = "i", silent = true })

			-- <S-F5> Shift adds 12 to the number for function keys
			wk.register({ ["<F17>"]	= { f17, "Debugger: Terminate"			} }, { mode = "n", silent = true })
			wk.register({ ["<F17>"]	= { f17, "Debugger: Terminate"			} }, { mode = "i", silent = true })

			wk.register({ ["<F9>" ] = { f9, "Debugger: Toggle Breakpoint"	} }, { mode = "n", silent = true })
			wk.register({ ["<F9>" ] = { f9, "Debugger: Toggle Breakpoint"	} }, { mode = "i", silent = true })

			wk.register({ ["<F10>"] = { f10, "Debugger: Step Over"			} }, { mode = "n", silent = true })
			wk.register({ ["<F10>"] = { f10, "Debugger: Step Over"			} }, { mode = "i", silent = true })

			wk.register({ ["<F11>"] = { f11, "Debugger: Step Into"			} }, { mode = "n", silent = true })
			wk.register({ ["<F11>"] = { f11, "Debugger: Step Into"			} }, { mode = "i", silent = true })

							-- <S-F11> Shift adds 12 to the number for function keys
			wk.register({ ["<F23>"] = { f12, "Debugger: Step Out"			} }, { mode = "n", silent = true })
			wk.register({ ["<F23>"] = { f12, "Debugger: Step Out"			} }, { mode = "i", silent = true })
			wk.register({ ["<F12>"] = { f12, "Debugger: Step Out"			} }, { mode = "n", silent = true })
			wk.register({ ["<F12>"] = { f12, "Debugger: Step Out"			} }, { mode = "i", silent = true })


			-- DAP bindings using <leader>d in a group
			wk.register({
				["<leader>d"] = {
					name = "Debugger",

					c = { f5,  "(F5)    Continue"			},
					n = { f10, "(F10)   Next"				},
					s = { f11, "(F11)   Step"				},
					s = { f12, "(F12)   Finish"				},
					q = { f17, "(S-F5)  Terminate"			},

					b = { f9,  "(F9)    Toggle Breakpoint"	},


					r = { function() require'dap'.repl.open()								end, "Open REPL"				},
					u = { function() require("dapui").toggle()								end, "Toggle UI"				},
					X = { function() require'dap'.clear_breakpoints()						end, "Clear Breakpoint"			},
					C = { function() 
							require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))()
																							end, "Conditional Breakpoint"	},
					t = { function() 
							require('dap-go').debug_test()
																							end, "Debug Test"				},

					k = { function() require'telescope'.extensions.dap.frames{}				end, "Backtrace"				},
					B = { function() require'telescope'.extensions.dap.list_breakpoints{}	end, "List Breakpoints"			},
					v = { function() require'telescope'.extensions.dap.variables{}			end, "Variables"				},

					e = { "<cmd>vsplit .vscode/launch.json<CR>",								 "Edit launch.json"			},

					["<tab>"] = { function() require('dap.ui.widgets').preview()			end, "View value under cursor"	},
				}
			}, { mode = "n", silent = true })

			-- Let's make it prettier
			vim.api.nvim_set_hl(0, 'DapBreakpoint',			{ ctermbg = 0, fg = '#993939', bg = '#31353f' })
			vim.api.nvim_set_hl(0, 'DapLogPoint',			{ ctermbg = 0, fg = '#61afef', bg = '#31353f' })
			vim.api.nvim_set_hl(0, 'DapStopped',			{ ctermbg = 0, fg = '#98c379', bg = '#31353f' })

			vim.fn.sign_define('DapStopped',				{ text='', texthl='DapStopped',	linehl='DapStopped',	numhl='DapStopped'		})
			vim.fn.sign_define('DapBreakpoint',				{ text='', texthl='DapBreakpoint',	linehl='DapBreakpoint',	numhl='DapBreakpoint'	})
			vim.fn.sign_define('DapBreakpointCondition',	{ text='', texthl='DapBreakpoint',	linehl='DapBreakpoint',	numhl='DapBreakpoint'	})
			vim.fn.sign_define('DapBreakpointRejected',		{ text='', texthl='DapBreakpoint',	linehl='DapBreakpoint',	numhl='DapBreakpoint'	})
			vim.fn.sign_define('DapLogPoint',				{ text='', texthl='DapLogPoint',	linehl='DapLogPoint',	numhl='DapLogPoint'		})


			dap.listeners.after.event_initialized["my_config"] = function()
			  -- require('dapui').open()
				require('dap').repl.open()	
			end

			dap.listeners.after.event_terminated["my_config"] = function()
				require('dap').repl.close()	
				require('dapui').close()
			end
			dap.listeners.after.event_exited["my_config"] = function()
				require('dap').repl.close()	
				require('dapui').close()
			end
		end
	},

	{
		'rcarriga/nvim-dap-ui',
		dependencies = {
			'mfussenegger/nvim-dap'
		},

		-- Don't load until triggered - The binding is above with the rest of
		-- the main dap bindings.
		keys = {
			{ "<leader>du", nil, "Toggle DAP UI" },
		},

		enabled = function()
			return vim.fn.has('unix')
		end,

		opts = {
			icons = { expanded = "▾", collapsed = "▸" },

			mappings = {
				-- Use a table to apply multiple mappings
				expand	= { "<CR>", "<2-LeftMouse>" },
				open	= "o", remove = "d", edit = "e", repl = "r", toggle = "t",
			},
			expand_lines = true,

			layouts = {{
				elements = {
					-- Elements can be strings or table with id and size keys.
					{ id = "scopes", size = 0.25 },
					-- "breakpoints",
					"stacks",
					-- "watches",
					"repl",
					"console",
				},

				size = 80, -- 80 columns
				position = "left",
			}},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "single", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil, -- Can be integer or nil.
			}
		}
	},

	{
		'theHamsta/nvim-dap-virtual-text',

		enabled = function()
			return vim.fn.has('unix')
		end,

		opts = {
			enabled						= true,		-- enable this plugin (the default)
			enabled_commands			= true,		-- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables	= true,		-- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed	= true,		-- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason			= true,		-- show stop reason when stopped for exceptions
			commented					= true,		-- prefix virtual text with comment string

			-- experimental features:
			virt_text_pos				= 'eol',	-- position of virtual text, see `:h nvim_buf_set_extmark()`
			all_frames					= false,	-- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
			virt_lines					= false,	-- show virtual lines instead of virtual text (will flicker!)
			virt_text_win_col			= 80,		-- position the virtual text at a fixed window column (starting from the first text column) ,
													-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
		}
	},

	{
		'nvim-telescope/telescope-dap.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},

		enabled = function()
			return vim.fn.has('unix')
		end,

		lazy = true,
		config = function()
			local telescope	= require('telescope')

			telescope.load_extension('dap')
		end
	},

	{
		'nvim-neotest/neotest-go',
		lazy = true,
	},
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-neotest/neotest-go'
		},

		lazy = true,
		cmd = {
			"Test", "TestFile", "TestDebugGo",
		},

		config = function()
			require("neotest").setup({
				adapters = {
					require('neotest-go'),
				},
			})

			-- Run the current test
			vim.api.nvim_create_user_command('Test', function(opts)
				require("neotest").run.run()
			end, { nargs=0 })

			-- Run all tests in this file
			vim.api.nvim_create_user_command('TestFile', function(opts)
				require("neotest").run.run(vim.fn.expand("%")) 
			end, { nargs=0 })

			-- Run the current test in the debugger (with go)
			vim.api.nvim_create_user_command('TestDebugGo', function(opts)
				require('dap-go').debug_test()
			end, { nargs=0 })
		end
	},

}
