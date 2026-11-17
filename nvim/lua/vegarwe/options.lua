-- Use :help 'option' to see the documentation for the given option.
local opt = vim.opt

-- Backups {{{
-- Keep a backup of every write, timestamped (see autocmds.lua), have saved me
-- many a times. Trailing // makes the file name include the full path.
local backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.fn.mkdir(backupdir, 'p')
opt.backup = true
opt.backupdir = backupdir
-- }}}

-- Share spell file with the vim config in this repo
local repo = vim.fs.dirname(vim.fn.resolve(vim.fn.stdpath('config')))
opt.spellfile = repo .. '/spell/en.utf-8.add'

-- Timeouts (hard timeout on multi-key mappings)
opt.timeoutlen = 100

-- UI & editor behaviour
opt.clipboard = 'unnamedplus'   -- put yanks/etc on the clipboard
opt.expandtab = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.tabstop = 4                 -- The One True Tab
opt.textwidth = 120
opt.colorcolumn = '+1'
opt.guicursor = 'n-v-c-i:block'
opt.cursorline = true
opt.title = true
opt.incsearch = false           -- noen syntes dette er nice, jeg synes ikke det :P
opt.inccommand = 'split'        -- live preview of :s in a split
opt.wrap = false                -- vi liker da ikke wrap'ing... bare dritt
opt.number = true
opt.relativenumber = true
opt.splitbelow = true
opt.splitright = true
opt.wildmode = { 'longest', 'list', 'full' }
opt.shortmess:append('at')      -- shortens messages to avoid 'press a key' prompt
opt.showmode = true
opt.scrolloff = 3
opt.sidescrolloff = 7
opt.sidescroll = 1
opt.fileformats:append('mac')
opt.suffixes:append({
  '.class', '.aux', '.log', '.dvi', '.bbl', '.blg', '.brf', '.cb', '.ind',
  '.idx', '.ilg', '.inx', '.out', '.toc',
})
opt.cinkeys:remove(':')
--opt.mouse = 'v'               -- vim had this, Neovim default is 'nvi'
--opt.smartcase = true

if vim.o.shell:match('fish$') then
  vim.o.shell = '/bin/bash'
end

-- Project local config (replaces sourcing .vimrc.custom). Reads .nvim.lua,
-- .nvimrc or .exrc from cwd and parents, but only after you :trust them.
opt.exrc = true

-- Colours
opt.termguicolors = true
vim.cmd.colorscheme('elflord')  -- the old favourite; Neovim's default is nice too
