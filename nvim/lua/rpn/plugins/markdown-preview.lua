return {
	"phunguyen19/markdown-preview.nvim",
	ft = { "markdown" },
	-- npm install rewrites the repo's tracked app/yarn.lock, which makes every
	-- subsequent `Lazy update` abort on local changes. The installer fetches a
	-- prebuilt binary instead and leaves the worktree clean.
	build = function()
		vim.cmd([[Lazy load markdown-preview.nvim]])
		vim.fn["mkdp#util#install_sync"](true)
	end,
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		-- Replaces the plugin's defaults wholesale, so they are restated here.
		-- empty_dict: a bare {} would reach the page as an array.
		vim.g.mkdp_preview_options = {
			mkit = vim.empty_dict(),
			katex = vim.empty_dict(),
			uml = vim.empty_dict(),
			maid = vim.empty_dict(),
			disable_sync_scroll = 0,
			sync_scroll_type = "middle",
			hide_yaml_meta = 1,
			sequence_diagrams = vim.empty_dict(),
			flowchart_diagrams = vim.empty_dict(),
			content_editable = false,
			disable_filename = 0,
			toc = vim.empty_dict(),
			side_toc = 1,
			content_width = "capped",
		}
	end,
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	keys = {
		{ "<leader>mmp", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Toggle markdown browser preview" },
	},
}
