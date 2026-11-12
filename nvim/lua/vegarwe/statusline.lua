-- Port of plugged/vim-statusline-vegarwe to Lua.
-- based on
-- * https://gist.github.com/suderman/1243665
-- * https://gist.github.com/scrooloose/vimfiles/blob/master/vimrc
local M = {}

local BIG_FILE = 300 * 1024 -- 300k source file is big....

-- Per buffer cache of the (expensive) warnings, cleared on CursorHold and
-- BufWritePost like the vimscript version did with b: variables.
local cache = {}

local function file_is_big(buf)
  return vim.fn.getfsize(vim.api.nvim_buf_get_name(buf)) > BIG_FILE
end

local function cached(buf, key, fn)
  cache[buf] = cache[buf] or {}
  if cache[buf][key] == nil then
    if file_is_big(buf) or not vim.bo[buf].modifiable then
      cache[buf][key] = ''
    else
      cache[buf][key] = fn(buf)
    end
  end
  return cache[buf][key]
end

-- '[\s]' if trailing white space is detected
local function trailing_space_warning()
  return vim.fn.search([[\s\+$]], 'nw') ~= 0 and [=[[\s]]=] or ''
end

-- '[&et]' if &et is set wrong, '[mixed-indenting]' if spaces and tabs are
-- used to indent
local function tab_warning(buf)
  local tabs = vim.fn.search([[\t]], 'nw') ~= 0
  -- find spaces that aren't used as alignment in the first indent column
  local spaces = vim.fn.search([[^ \{]] .. vim.bo[buf].tabstop .. [[,}[^\t]], 'nw') ~= 0
  local et = vim.bo[buf].expandtab
  if tabs and spaces then
    return '[mixed-indenting]'
  elseif (spaces and not et) or (tabs and et) then
    return '[&et]'
  end
  return ''
end

-- '[#x,my,$z]' for "long lines" (longer than &textwidth, or 80): x is the
-- number of long lines, y the median length and z the longest
local function long_line_warning(buf)
  local tw = vim.bo[buf].textwidth
  local threshold = tw > 0 and tw or 80
  local lens = {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if #line > threshold then -- cheap byte check first
      local len = vim.fn.strdisplaywidth(line)
      if len > threshold then
        lens[#lens + 1] = len
      end
    end
  end
  if #lens == 0 then
    return ''
  end
  table.sort(lens)
  local n = #lens
  local median = n % 2 == 1 and lens[(n + 1) / 2] or math.floor((lens[n / 2] + lens[n / 2 + 1]) / 2)
  return ('[#%d,m%d,$%d]'):format(n, median, lens[n])
end

local function diagnostics(buf)
  local s = vim.diagnostic.status(buf)
  return s ~= '' and '[' .. s .. ']' or ''
end

-- Show value normally when it is one of the good values, else in error colour
local function flag(value, good)
  if value == good then
    return value
  end
  return '%6*' .. value .. '%5*'
end

local function file_size(buf)
  local bytes = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
  if bytes <= 0 then
    return ''
  elseif bytes < 1024 then
    return '[' .. bytes .. ']'
  end
  return '[' .. math.floor(bytes / 1024) .. 'K]'
end

local function esc(s)
  return (s:gsub('%%', '%%%%'))
end

-- Git branch, fetched asynchronously (replaces fugitive#statusline())
local function update_branch(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local dir = name ~= '' and vim.fs.dirname(name) or vim.fn.getcwd()
  if vim.bo[buf].buftype ~= '' or vim.fn.isdirectory(dir) == 0 then
    return
  end
  vim.system({ 'git', 'branch', '--show-current' }, { cwd = dir, text = true }, function(res)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.b[buf].git_branch = res.code == 0 and vim.trim(res.stdout) or nil
        vim.cmd.redrawstatus()
      end
    end)
  end)
end

-- Called through %{% %}, so the window/buffer being drawn is "current"
function M.render()
  local buf = vim.api.nvim_get_current_buf()
  local branch = vim.b[buf].git_branch
  local fenc = vim.bo[buf].fileencoding
  local parts = {
    -- window section: buffer number and git branch
    '%1*%< %n ',
    branch and branch ~= '' and ('[Git(' .. esc(branch) .. ')] ') or '',
    '%*',
    -- file name section
    '%2* %<%f%=%*',
    -- info section
    '%3*%r%m%*',
    -- warning section
    '%4* ',
    esc(diagnostics(buf)),
    cached(buf, 'long', long_line_warning),
    cached(buf, 'tab', tab_warning),
    cached(buf, 'trailing', trailing_space_warning),
    ' %*',
    -- file info section
    '%5* %h%y[',
    flag(vim.bo[buf].fileformat, 'unix'),
    ',',
    flag(fenc ~= '' and fenc or vim.o.encoding, 'utf-8'),
    ']',
    file_size(buf),
    ' %*',
    -- nav section
    '%1*%14(%c:%3l/%L%) %P %*',
  }
  return table.concat(parts)
end

local function set_highlights()
  local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end
  hl('User1', { ctermbg = 190, ctermfg = 'Black', bg = '#d7ff00', fg = '#000000' })
  hl('User2', { ctermbg = 234, ctermfg = 121, bg = '#1c1c1c', fg = '#87ffaf' })
  hl('User3', { ctermbg = 234, ctermfg = 'White', bg = '#1c1c1c', fg = '#ffffff' })
  hl('User4', { ctermbg = 234, ctermfg = 'Red', bg = '#1c1c1c', fg = '#ff5f5f' })
  hl('User5', { ctermbg = 130, ctermfg = 'Black', bg = '#af5f00', fg = '#000000' })
  hl('User6', { ctermbg = 130, ctermfg = 'Red', bg = '#af5f00', fg = '#ff0000', bold = true })
end

function M.setup()
  set_highlights()
  vim.o.laststatus = 2
  vim.o.statusline = "%{%v:lua.require'vegarwe.statusline'.render()%}"

  local group = vim.api.nvim_create_augroup('vegarwe_statusline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_highlights })
  -- recalculate the warnings when idle, and after saving
  vim.api.nvim_create_autocmd({ 'CursorHold', 'BufWritePost' }, {
    group = group,
    callback = function(args) cache[args.buf] = nil end,
  })
  vim.api.nvim_create_autocmd('BufWipeout', {
    group = group,
    callback = function(args) cache[args.buf] = nil end,
  })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'BufWritePost', 'DirChanged' }, {
    group = group,
    callback = function(args) update_branch(args.buf) end,
  })
end

return M
