local group = vim.api.nvim_create_augroup('vegarwe', { clear = true })
local autocmd = function(event, opts)
  opts.group = group
  vim.api.nvim_create_autocmd(event, opts)
end

-- Add timestamp as extension for backup files
autocmd('BufWritePre', {
  desc = 'Add timestamp to backup extension',
  callback = function()
    vim.o.backupext = '-' .. os.date('%Y%m%d%H%M')
  end,
})

-- Highlight end of line white space (and space/tab mixes)
local function whitespace_hl()
  vim.api.nvim_set_hl(0, 'WhitespaceEOL', { ctermbg = 'red', bg = 'red' })
end
whitespace_hl()
autocmd('ColorScheme', { callback = whitespace_hl })
autocmd('BufWinEnter', {
  callback = function()
    vim.cmd([[match WhitespaceEOL /\s\+$\| \+\ze\t\|\t\+\ze /]])
  end,
})

-- If we have a saved position in the file, go there.
-- Don't do it when writing a commit log entry.
autocmd('BufReadPost', {
  callback = function(args)
    if vim.bo[args.buf].filetype:match('svn') or vim.bo[args.buf].filetype:match('commit') then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd('normal! zz')
    end
  end,
})

-- Open multiple files from the command line in tabs (like nvim -p), unless a
-- layout was asked for (-o, -O, -p, -d). nested so BufReadPost etc. fire.
autocmd('VimEnter', {
  nested = true,
  callback = function()
    if vim.fn.argc() > 1 and not vim.o.diff
        and #vim.api.nvim_list_tabpages() == 1 and #vim.api.nvim_list_wins() == 1 then
      vim.cmd('tab all')
      vim.cmd('tabfirst')
    end
  end,
})

-- Spell check when writing commit logs
autocmd('FileType', {
  pattern = { 'svn', '*commit*' },
  callback = function() vim.opt_local.spell = true end,
})

-- Ftplugins reset formatoptions, so remove 'o' after they have run
autocmd('FileType', {
  callback = function() vim.opt_local.formatoptions:remove('o') end,
})

-- Per file type changes
autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
