local o				= vim.o		-- options
local g				= vim.g		-- global options
local wo			= vim.wo	-- window options
local bo			= vim.bo	-- buffer options
local lo			= vim.opt_local

o.swapfile			= false

-- Do NOT unload hidden buffer
o.hidden			= true

-- Needed for firenvim
o.guifont			= "Hack:h14"
o.ruler				= true
wo.signcolumn		= "yes"

-- If a buffer is open in another tab, switch to that instead of poluting the current tab
o.switchbuf			= "usetab,uselast"

o.mapleader			= "\\"
o.visualbell		= true	-- I'd prefer a flash over a beep
o.wildmenu			= true
o.wildmode			= "list:longest"

o.hlsearch			= true
o.incsearch			= true

o.smartcase			= true
o.hlsearch			= true
o.ignorecase		= true
o.title				= true
o.scrolloff			= 10
o.sidescrolloff		= 10
o.sidescroll		= 1
o.laststatus		= 3		-- Display a single status bar for all windows

wo.number			= false
wo.wrap				= false

wo.foldenable		= false

bo.textwidth		= 80
vim.opt.colorcolumn	= "80"


-- Use my make wrapper, which will walk up to find a Makefile
o.makeprg			= 'make-parent'


-- Ignore files of these types
o.wildignore		= "*.swp,*.o,*.la,*.lo,*.a"
o.suffixes			= o.wildignore


-- Improve the file browser
g.netrw_banner		= false
g.netrw_altv		= true	-- open splits to the right
g.netrw_preview		= true	-- preview split to the right
g.netrw_liststyle	= 3		-- tree view


-- I despise auto formating, auto indent, etc.
-- 
-- Whenever opening any file, regardless of what plugins may do, turn that
-- shit off!
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead", "BufEnter", "BufWinEnter", "FileType"}, {
	pattern = { "*" },
	callback = function()
		bo.autoindent		= false
		bo.smartindent		= false
		bo.cindent			= false
		bo.indentexpr		= ""
		bo.formatoptions	= ""

		bo.autoread			= true
		bo.expandtab		= false

		bo.tabstop			= 4		-- Tabs are 4 wide - I'm not a monster!
		bo.softtabstop		= 4
		bo.shiftwidth		= 4
	end,
})

-- Auto reload contents of a buffer
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_command('checktime')
	end,
})



-- Show relative numbers in the active window, and absolute in others
vim.api.nvim_create_autocmd({"WinLeave"}, {
	pattern = { "*" },
	callback = function()
		wo.relativenumber	= false
		wo.number			= true
		wo.numberwidth		= 5
	end,
})
vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
	pattern = { "*" },
	callback = function()
		wo.relativenumber	= true
		wo.number			= true
		wo.numberwidth		= 5
	end,
})

-- Show crosshairs but only in the active window
vim.api.nvim_create_autocmd({"WinLeave"}, {
	pattern = { "*" },
	callback = function()
		wo.cursorline		= false
		wo.cursorcolumn		= false
	end,
})
vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
	pattern = { "*" },
	callback = function()
		wo.cursorline		= true
		wo.cursorcolumn		= true
	end,
})

-- Help me spell
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = { "*.txt", "*.md" },
	callback = function()
		lo.spell			= true
		lo.wrap				= true
	end,
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = { "*.cmake", "CMakeLists.txt" },
	callback = function()
		lo.spell			= false
		lo.wrap				= false
	end,
})

-- I resize my terminal frequently
vim.api.nvim_create_autocmd({"VimResized"}, {
	pattern = { "*" },
	command = "wincmd ="
})

-- Terminal
vim.api.nvim_create_autocmd({"TermOpen", "TermEnter", "BufEnter"}, {
	pattern = { "term://*" },
	callback = function()
		wo.relativenumber	= false
		wo.number			= false
		o.signcolumn		= "no"

		vim.cmd([[ startinsert ]])
	end,
})

