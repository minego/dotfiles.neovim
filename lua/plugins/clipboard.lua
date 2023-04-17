return {
	{ 'ojroques/nvim-osc52' },
	opts = {
		max_length = 0,      -- Maximum length of selection (0 for no limit)
		silent     = true,   -- Disable message on successful copy
		trim       = true,  -- Trim surrounding whitespaces before copy
	}

	config = function()
		function copy()
			if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
				require('osc52').copy_register('+')
			end
		end

		vim.api.nvim_create_autocmd('TextYankPost', {callback = copy})
	end
}
