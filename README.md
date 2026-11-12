# vimrc.vim

A cloneable all-in-on-folder .vimrc for easy setup on a new machine. Highly
personal, not recommended for wide use...

- Clone tree:
  - git clone git@github.com:vegarwe/vim-vimrc.git ~/.vim
- Install all plugins
  - - choco
  - - node
  - - yarn
  - :PlugInstall
  - :CocInstall coc-clangd
  - :CocCommand clangd.install
- Done or something

## Neovim

The Neovim config lives in `nvim/` (Lua, no plugins yet).

- ln -s ~/.vim/nvim ~/.config/nvim
- Backups go to `~/.local/state/nvim/backup/`, spell words are shared with vim
- `.vimrc.custom` is replaced by `exrc`: put a `.nvim.lua` in the project and `:trust` it
