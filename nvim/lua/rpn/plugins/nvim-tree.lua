return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			-- Default <C-k> (info popup) shadows vim-tmux-navigator pane switching
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.del("n", "<C-k>", { buffer = bufnr })
				vim.keymap.set("n", "<M-k>", api.node.show_info_popup, {
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
					desc = "nvim-tree: Info",
				})

				-- Yank path of node under cursor (shadows global buffer-path yanks)
				local yank = require("rpn.core.yank")
				local function yank_node(modifier, label)
					local node = api.tree.get_node_under_cursor()
					if not node or not node.absolute_path then
						return
					end
					local path = modifier and vim.fn.fnamemodify(node.absolute_path, modifier) or node.absolute_path
					yank.yank_path(path, label)
				end
				local function opts(desc)
					return { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "nvim-tree: " .. desc }
				end
				vim.keymap.set("n", "<leader>ya", function()
					yank_node(nil, "absolute")
				end, opts("Yank absolute path"))
				vim.keymap.set("n", "<leader>yr", function()
					yank_node(":.", "relative")
				end, opts("Yank relative path"))
			end,
			view = {
				width = 35,
				number = true,
				relativenumber = true,
				adaptive_size = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			-- Info messages (e.g. "added to clipboard") trigger the hit-enter prompt
			notify = {
				threshold = vim.log.levels.WARN,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
