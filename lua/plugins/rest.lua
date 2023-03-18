return {
	{
		'diepm/vim-rest-console',

		lazy = false, -- The plugin does its own ft detection
		cmd = "Rest",

		config = function()
			vim.cmd[[ command! Rest call VrcQuery() ]]
		end
	}
}
