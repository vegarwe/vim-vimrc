local map = vim.keymap.set

-- Leader is still the default '\'
map('n', '<Leader>w', '<Cmd>w<CR>')

--map('n', '<F4>', '<Cmd>set invnumber<CR>')
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
