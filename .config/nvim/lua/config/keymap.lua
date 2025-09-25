-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = true, silent = true }

-- Window Management Splits
vim.keymap.set("n", "<leader>s|", "<C-w>v", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>s-", "<C-w>s", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Window Management Move Window
vim.keymap.set("n", "<leader>mk", "<C-w>K", { desc = "Move Window Vertically Top" })
vim.keymap.set("n", "<leader>mj", "<C-w>J", { desc = "Move Window Vertically Bottom" })
vim.keymap.set("n", "<leader>mh", "<C-w>H", { desc = "Move Window Horizontally Left" })
vim.keymap.set("n", "<leader>ml", "<C-w>L", { desc = "Move Window Horizontally Right" })

-- Window Management Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to Bottom Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to Top Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to Right Window" })

-- Create New Window Pane TMUX
vim.keymap.set("n", "<leader>t|", "<cmd>silent !tmux split-window -h<cr>", { desc = "New Window Pane Horizontal" })
vim.keymap.set("n", "<leader>t-", "<cmd>silent !tmux split-window -v<cr>", { desc = "New Window Pane Vertical" })

-- Clear Highlight
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear Search Highlights" })

-- Lazy
vim.keymap.set("n", "<leader>lz", ":Lazy<CR>", { desc = "Open Lazy" })

-- Save & Quit
vim.keymap.set("n", "<M-s>", ":w<CR>", { desc = "Save" })

-- Delete All Buffer Except Current
vim.keymap.set("n", "<leader>bw", "<CMD>1,.-bdelete<CR>", { desc = "Delete All Buffer Except Current" })

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize -2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<M-w>", "<CMD>bd<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
