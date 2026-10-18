vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "sage"

local p = {
  bg = "#13171b", panel = "#1a2026", fg = "#cfd7de", muted = "#6c7884",
  sage = "#7eb898", green = "#5d9876", mint = "#8ed4aa", border = "#293d33",
  disabled = "#38424b", red = "#e06c75", yellow = "#d7ba7d", blue = "#83a6c8",
  purple = "#b4a1db", teal = "#72b7b2",
}

local groups = {
  Normal = { fg = p.fg, bg = p.bg }, NormalNC = { fg = p.fg, bg = p.bg },
  NormalFloat = { fg = p.fg, bg = p.panel }, FloatBorder = { fg = p.green, bg = p.panel },
  SignColumn = { fg = p.muted, bg = p.bg }, LineNr = { fg = p.muted },
  CursorLine = { bg = p.panel }, CursorLineNr = { fg = p.mint, bold = true },
  ColorColumn = { bg = p.panel }, WinSeparator = { fg = p.border }, VertSplit = { fg = p.border },
  StatusLine = { fg = p.fg, bg = p.panel }, StatusLineNC = { fg = p.muted, bg = p.bg },
  TabLine = { fg = p.muted, bg = p.panel }, TabLineSel = { fg = p.bg, bg = p.sage, bold = true },
  TabLineFill = { bg = p.bg }, Pmenu = { fg = p.fg, bg = p.panel }, PmenuSel = { fg = p.bg, bg = p.sage, bold = true },
  Visual = { bg = "#293d33" }, Search = { fg = p.bg, bg = p.mint }, IncSearch = { fg = p.bg, bg = p.yellow },
  MatchParen = { fg = p.mint, bold = true, underline = true },
  Comment = { fg = p.muted, italic = true }, Constant = { fg = p.yellow }, String = { fg = p.mint },
  Character = { fg = p.mint }, Number = { fg = p.yellow }, Boolean = { fg = p.yellow }, Float = { fg = p.yellow },
  Identifier = { fg = p.fg }, Function = { fg = p.blue }, Statement = { fg = p.purple },
  Conditional = { fg = p.purple }, Repeat = { fg = p.purple }, Label = { fg = p.teal },
  Operator = { fg = p.teal }, Keyword = { fg = p.purple }, Exception = { fg = p.red },
  PreProc = { fg = p.teal }, Include = { fg = p.teal }, Define = { fg = p.teal },
  Type = { fg = p.sage }, StorageClass = { fg = p.sage }, Structure = { fg = p.sage },
  Special = { fg = p.teal }, Error = { fg = p.red, bold = true }, Todo = { fg = p.bg, bg = p.yellow, bold = true },
  DiagnosticError = { fg = p.red }, DiagnosticWarn = { fg = p.yellow }, DiagnosticInfo = { fg = p.blue }, DiagnosticHint = { fg = p.teal },
  DiagnosticSignError = { fg = p.red }, DiagnosticSignWarn = { fg = p.yellow }, DiagnosticSignInfo = { fg = p.blue }, DiagnosticSignHint = { fg = p.teal },
  GitSignsAdd = { fg = p.sage }, GitSignsChange = { fg = p.yellow }, GitSignsDelete = { fg = p.red },
  NvimTreeNormal = { fg = p.fg, bg = p.panel }, NvimTreeNormalNC = { fg = p.fg, bg = p.panel },
  NvimTreeRootFolder = { fg = p.sage, bold = true }, NvimTreeFolderName = { fg = p.fg },
  NvimTreeOpenedFolderName = { fg = p.mint, bold = true }, NvimTreeIndentMarker = { fg = p.disabled },
  NvimTreeWinSeparator = { fg = p.border, bg = p.bg },
  ["@comment"] = { fg = p.muted, italic = true }, ["@string"] = { fg = p.mint },
  ["@number"] = { fg = p.yellow }, ["@boolean"] = { fg = p.yellow }, ["@function"] = { fg = p.blue },
  ["@function.call"] = { fg = p.blue }, ["@keyword"] = { fg = p.purple }, ["@operator"] = { fg = p.teal },
  ["@type"] = { fg = p.sage }, ["@variable"] = { fg = p.fg }, ["@property"] = { fg = p.teal },
  ["@markup.heading"] = { fg = p.mint, bold = true }, ["@markup.strong"] = { fg = p.sage, bold = true },
  ["@markup.italic"] = { fg = p.fg, italic = true }, ["@markup.link"] = { fg = p.blue, underline = true },
  ["@markup.raw"] = { fg = p.mint }, ["@markup.list"] = { fg = p.sage },
}

for name, style in pairs(groups) do vim.api.nvim_set_hl(0, name, style) end
