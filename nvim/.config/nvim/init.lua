-- ============================
-- 基础设置
-- ============================
vim.opt.number = true              -- 显示行号
vim.opt.relativenumber = true      -- 相对行号
vim.opt.tabstop = 2                -- Tab 显示为 2 空格
vim.opt.shiftwidth = 2             -- 缩进宽度为 2 空格
vim.opt.expandtab = true           -- Tab 转为空格
vim.opt.smartindent = true         -- 智能缩进
vim.opt.wrap = false               -- 不自动换行
vim.opt.ignorecase = true          -- 搜索忽略大小写
vim.opt.smartcase = true           -- 有大写时区分大小写
vim.opt.guicursor = ""             -- 块状光标
vim.opt.cursorline = true          -- 高亮当前行
vim.opt.showcmd = true             -- 右下角显示输入的按键
vim.opt.showmode = false           -- 隐藏左下角的模式提示
vim.opt.termguicolors = true       -- 启用真彩色
vim.opt.signcolumn = "yes"         -- 始终显示符号列
vim.opt.updatetime = 250           -- 减少触发延迟
vim.opt.undofile = true            -- 持久化撤销历史
vim.opt.clipboard = "unnamedplus"  -- 共享系统剪贴板
vim.opt.shortmess:append("I")      -- 禁用首页欢迎信息
vim.g.mapleader = " "              -- 空格作为 Leader 键

-- ============================
-- 暗色护眼主题（黑橙高对比度）
-- ============================
vim.api.nvim_set_hl(0, "Normal",        { bg = "#111111", fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "CursorLine",    { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "VertSplit",     { fg = "#333333" })
vim.api.nvim_set_hl(0, "LineNr",        { fg = "#555555" })
vim.api.nvim_set_hl(0, "CursorLineNr",  { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Comment",       { fg = "#666666", italic = true })
vim.api.nvim_set_hl(0, "String",        { fg = "#66bb6a" })
vim.api.nvim_set_hl(0, "Keyword",       { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Function",      { fg = "#ffcc00" })
vim.api.nvim_set_hl(0, "Variable",      { fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "Constant",      { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Identifier",    { fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "Statement",     { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Type",          { fg = "#ffcc00" })
vim.api.nvim_set_hl(0, "Operator",      { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Number",        { fg = "#ff8800" })
vim.api.nvim_set_hl(0, "Special",       { fg = "#ffcc00" })
vim.api.nvim_set_hl(0, "Search",        { bg = "#ff8800", fg = "#111111" })
vim.api.nvim_set_hl(0, "Visual",        { bg = "#333333" })
vim.api.nvim_set_hl(0, "MatchParen",    { bg = "#ff8800", fg = "#111111", bold = true })
vim.api.nvim_set_hl(0, "Pmenu",         { bg = "#1a1a1a", fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "PmenuSel",      { bg = "#ff8800", fg = "#111111" })
vim.api.nvim_set_hl(0, "StatusLine",    { bg = "#1a1a1a", fg = "#ff8800" })

-- ============================
-- 自动补全括号
-- ============================
vim.keymap.set("i", "(", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == ")" then
    return "<Right>"
  else
    return "()<left>"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "[", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "]" then
    return "<Right>"
  else
    return "[]<left>"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "{", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "}" then
    return "<Right>"
  else
    return "{}<left>"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "`", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "`" then
    return "<Right>"
  else
    return "``<left>"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", ")", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == ")" then
    return "<Right>"
  else
    return ")"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "]", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "]" then
    return "<Right>"
  else
    return "]"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "}", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "}" then
    return "<Right>"
  else
    return "}"
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", '"', function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == '"' then
    return "<Right>"
  elseif line:sub(col - 1, col - 1) == '"' then
    return "<Right>"
  else
    return '""<left>'
  end
end, { noremap = true, expr = true })

vim.keymap.set("i", "'", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  if line:sub(col, col) == "'" then
    return "<Right>"
  elseif line:sub(col - 1, col - 1) == "'" then
    return "<Right>"
  else
    return "''<left>"
  end
end, { noremap = true, expr = true })

-- ============================
-- 快捷键
-- ============================
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- ============================
-- 插件（lazy.nvim）
-- ============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvzone/showkeys",
    event = "VimEnter",
    opts = {
      timeout = 1,
      maxkeys = 1,
      position = "bottom-right",
      show_count = false,
    },
    config = function(_, opts)
      require("showkeys").setup(opts)
      require("showkeys").open()
    end,
  },
})
