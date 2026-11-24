return {
	"petertriho/nvim-scrollbar",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"kevinhwang91/nvim-hlslens",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		-- hlslens: search match counter + virtual text
		require("hlslens").setup()

		local kopts = { noremap = true, silent = true }
		vim.keymap.set(
			"n",
			"n",
			[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.keymap.set(
			"n",
			"N",
			[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

		-- scrollbar (v2): thumb color from melange palette (dark a.sel = #403A36),
		-- transparent bg means the thumb needs an explicit color to be visible.
		-- cursor, diagnostic and search providers are on by default; search reads
		-- native / and ? directly, so no hlslens wiring is needed for marks.
		require("scrollbar").setup({
			providers = {
				gitsigns = true,
			},
			scrollbar = {
				thumb = { highlight = { bg = "#403A36" } },
			},
		})
	end,
}
