-- Modda av meg sjæl våren 2004 - brukt alfborge's som samt gentoo's som grunnlag
-- vimrc konvertert til Neovim Jula 2024, ryddet opp november 2026
--
-- Install: ln -s <this repo>/nvim ~/.config/nvim
--
-- Lots of the old vimrc is Neovim default and therefore not repeated here,
-- see :help vim-differences. Notably: autoindent, backspace, smarttab,
-- nrformats-=octal, hidden, hlsearch, laststatus=2, ruler, showcmd, wildmenu,
-- display=lastline, autoread, history, tabpagemax, formatoptions+=j,
-- listchars, belloff=all, i_CTRL-U undo break, <C-L> clears hlsearch.

require('vegarwe.options')
require('vegarwe.keymaps')
require('vegarwe.autocmds')
require('vegarwe.statusline').setup()
