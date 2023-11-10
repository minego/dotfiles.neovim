return {
	'harrisoncramer/gitlab.nvim',

	dependencies = {
		'MunifTanjim/nui.nvim',
		'nvim-lua/plenary.nvim',
		'stevearc/dressing.nvim', -- Recommended but not required. Better UI for pickers.
		'sindrets/diffview.nvim',
		enabled = true,
	},

	build = function () require("gitlab.server").build(true) end, -- Builds the Go binary
	config = function()
		local wk		= require("which-key")
		local gitlab	= require("gitlab")

		gitlab.setup({
			reviewer = "diffview",
			popup = {
				exit = "<Esc>",
				perform_action = "<leader>s",
				perform_linewise_action = "<enter>",
			},
		})

		wk.register({
			["<leader>l"] = {
				name = "Gitlab",

				r = { gitlab.review,				"Review" },
				s = { gitlab.summary,				"Summary" },
				A = { gitlab.approve,				"Approve" },
				R = { gitlab.revoke,				"Revoke" },
				c = { gitlab.create_comment,		"Comment" },
				n = { gitlab.create_note,			"Add Note" },
				d = { gitlab.toggle_discussions,	"Toggle Discussions" },
				aa= { gitlab.add_assignee,			"Add Assignee" },
				ad= { gitlab.delete_assignee,		"Delete Assignee" },
				ra= { gitlab.add_reviewer,			"Add Reviewer" },
				rd= { gitlab.delete_reviewer,		"Delete Reviewer" },
				p = { gitlab.pipeline,				"Pipeline" },
				o = { gitlab.open_in_browser,		"Open in Browser" },
			}
		}, { mode = "n", silent = true })
	end,
}
