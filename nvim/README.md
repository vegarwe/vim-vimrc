# Neovim config

Lua port of `../vimrc` (and of the old `vim-statusline-vegarwe` status line),
written for Neovim 0.12. No plugins yet.

## Install

    ln -s <this repo>/nvim ~/.config/nvim

The symlink must point at the repo's current location, so recreate it if the
repo moves. The spell file path is computed from where the symlink resolves to,
so `../spell/en.utf-8.add` is shared with vim.

## Layout

- `init.lua` loads the modules below. Its header comment lists the vimrc
  settings that were dropped because Neovim already has them as defaults
  (hidden, hlsearch, autoread, `<C-L>` nohlsearch, i_`<C-U>` undo break, ...).
- `lua/vegarwe/options.lua` holds the settings. Where the vimrc and the 2024 Lua
  attempt (`nvim_lua_fisken_init.lua`) disagreed, the Lua attempt won:
  `clipboard=unnamedplus`, `textwidth=120`, cursorline, `inccommand=split`,
  block cursor, mouse left at the Neovim default. Backups go to
  `~/.local/state/nvim/backup/` with a timestamp extension.
- `lua/vegarwe/keymaps.lua` holds the keymaps. The vimrc's `.vimrc.custom`
  became `exrc`: put a `.nvim.lua` in the project and approve it with `:trust`.
- `lua/vegarwe/autocmds.lua`:
  - timestamped backups
  - trailing-whitespace highlight
  - return to the last cursor position. Saved positions live in ShaDa; files
    under `/tmp` are never remembered (the default `shada` has `r/tmp/`).
  - several files on the command line open in tabs, like `nvim -p`. This is a
    nested `VimEnter` autocmd and is skipped for `-o`, `-O`, `-p` and `-d`.
  - spell check in commit messages, `formatoptions-=o`, TypeScript indent of 2
- `lua/vegarwe/statusline.lua` is the old status line rewritten in Lua with the
  same sections and User1–6 colours. Fugitive's branch was replaced by an async
  `git branch --show-current` call, and YouCompleteMe's loclist count by
  `vim.diagnostic.status()`.

## What changed from vim

- Visual `v` / `<C-v>` grow and shrink the selection using the built-in
  `an` / `in` (treesitter or LSP) instead of vim-expand-region. They only work
  where a parser or language server is available.
- The F3 paste toggle is gone (`pastetoggle` was removed from Neovim; bracketed
  paste makes it unnecessary).
- Colour scheme is the Neovim default; `elflord` is commented out in
  `options.lua`.
- Not ported yet because they need plugins: `<F1>` NERDTreeToggle,
  `<Leader>g` `:Git`, `gd` via coc (opened the definition in a new tab).

## Next steps

1. **Plugin manager:** use the built-in `vim.pack.add{...}` (Neovim 0.12). No
   need for vim-plug or lazy.nvim.
2. **coc.nvim → built-in LSP.** This is the biggest win.
   - Use `vim.lsp.enable('clangd')` etc., with `neovim/nvim-lspconfig` providing
     the server configs.
   - Completion: try the built-in
     `vim.lsp.completion.enable(true, client.id, buf, {autotrigger=true})` from
     an `LspAttach` autocmd first; move to `saghen/blink.cmp` only if it isn't
     enough.
   - Built-in keymaps: `K` hover, `grn` rename, `gra` code action,
     `grr` references, `gri` implementation, `]d`/`[d` diagnostics.
   - Recreate `gd` as "definition in new tab" with
     `vim.lsp.buf.definition` plus an `on_list` callback that runs
     `:tabedit`, or simply `<C-w>]` / `<C-w>gd` style.
   - The status line already shows diagnostics through
     `vim.diagnostic.status()`.
3. **nvim-treesitter** (main branch; it was rewritten, so check its README for
   installing parsers). This gives syntax highlighting, and makes the `v` / `an`
   expand-selection work in more languages. Neovim only ships parsers for
   c, lua, vim, vimdoc, query and markdown.
4. **ctrlp → fuzzy finder:** `ibhagwan/fzf-lua` (or telescope / snacks.picker)
   for files, buffers (could replace the F5 `:ls<CR>:b` mapping), grep and LSP
   symbols.
5. **Git:** keep `tpope/vim-fugitive`, it works fine in Neovim. Restore
   `<Leader>g :Git<Space>`. Add `lewis6991/gitsigns.nvim` for change markers next
   to the line numbers and hunk staging. The status line could then use
   `vim.b.gitsigns_head` instead of running git itself.
6. **nerdtree →** `stevearc/oil.nvim` (edit a directory like a buffer) or
   `nvim-tree/nvim-tree.lua` for a sidebar. Remap `<F1>`.
7. **Colour schemes:** dracula, everforest and gruvbox have Lua versions
   (e.g. `ellisonleao/gruvbox.nvim`); tokyonight and kanagawa are popular too.
   The status line re-applies User1–6 on `ColorScheme`.
8. **Small things:**
   - `vim.o.undofile = true` so undo history survives restarts; try the
     built-in `:Undotree`.
   - `timeoutlen=100` is very short for two-key leader mappings like
     `<Leader>cc`, and that gets worse as LSP and picker maps are added.
     Consider 300–500.
   - `tpope/vim-rsi` still works if readline keys are missed.
   - `nvim_lua_fisken_init.lua` in the repo root is the 2024 attempt. It is
     fully superseded and was never committed, so it can be deleted.
