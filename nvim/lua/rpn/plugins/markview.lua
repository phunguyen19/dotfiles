-- In-buffer markdown rendering. The plugin lazy-loads itself, so lazy.nvim must
-- not (upstream warns lazy-loading slows the first preview).
return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		preview = {
			enable = false,
			icon_provider = "devicons",
		},
	},
}
