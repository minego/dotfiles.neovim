-- Bootstrap the package manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load settings before loading plugins
require('settings')

-- Load plugins
local lazy = require("lazy")

if os.getenv("NVIM") ~= nil then
	-- If opening from inside neovim terminal then do not load all the other plugins
    lazy.setup {
        {'willothy/flatten.nvim', config = true },
    }
    return
else
	-- Load all plugins
	lazy.setup("plugins")
end

-- Set the correct shell for windows
if (vim.fn.has('unix') == 0) then
	vim.o.shell = "cmd.exe"
end
