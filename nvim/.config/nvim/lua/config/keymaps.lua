local map = vim.keymap.set
local opts = { silent = true }

map({"n", "v"}, "<Space>", "<Nop>", { silent = true })
map("n", "<leader>w", "<cmd>w<cr>", vim.tbl_extend("force", opts, { desc = "Write buffer" }))
map("n", "<leader>q", "<cmd>bd<cr>", vim.tbl_extend("force", opts, { desc = "Close buffer" }))
map("n", "<leader>h", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Left window" }))
map("n", "<leader>j", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Lower window" }))
map("n", "<leader>k", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Upper window" }))
map("n", "<leader>l", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Right window" }))
map("n", "<Esc>", "<cmd>nohlsearch<cr>", vim.tbl_extend("force", opts, { desc = "Clear highlights" }))
map("n", "gl", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
