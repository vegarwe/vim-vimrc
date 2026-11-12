local map = vim.keymap.set

-- Leader is still the default '\'
map('n', '<Leader>w', '<Cmd>w<CR>')

-- Make it possible to select text with the mouse (for copying)
local function toggle_select_mode()
  if vim.wo.colorcolumn ~= '' then
    vim.wo.colorcolumn = ''
    vim.wo.wrap = true
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.colorcolumn = '+1'
    vim.wo.wrap = false
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end
map('n', '<Leader>cc', toggle_select_mode, { desc = 'Toggle select mode' })
map('n', '<F2>', toggle_select_mode, { desc = 'Toggle select mode' })

-- F3 used to be pastetoggle; bracketed paste makes it unnecessary in Neovim
map('n', '<F4>', '<Cmd>set invnumber<CR>')
map('n', '<F5>', ':ls<CR>:b')

-- Navigate tabs with space and backspace! Really nice
map('n', '<Space>', '<Cmd>tabnext<CR>')
map('n', '<BS>', '<Cmd>tabprevious<CR>')

-- Expand/shrink selection (replaces vim-expand-region). Uses the built-in
-- treesitter / LSP incremental selection (:help v_an).
map('x', 'v', 'an', { remap = true, desc = 'Expand selection' })
map('x', '<C-v>', 'in', { remap = true, desc = 'Shrink selection' })

-- Have typed q: instead of :q too many times to count
map('n', 'q:', ':q')

-- Don't use Ex mode (or macro replay, as Neovim has it), use Q for formatting
map({ 'n', 'x' }, 'Q', 'gq')

-- Normal mode <C-L> already clears hlsearch in Neovim; do it in insert too
map('i', '<C-L>', '<Cmd>nohlsearch<CR>')
