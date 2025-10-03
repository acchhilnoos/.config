-- OPTS
vim.o.guicursor = ''
vim.o.mouse = ''

vim.o.cc        = "80"      -- colorcolumn
vim.o.ch        = 1         -- cmdheight
vim.o.cot       = ''        -- completeopt
vim.o.et        = true      -- expandtab
vim.o.fdl       = 99        -- foldlevel
vim.o.fdls      = 99        -- foldlevelstart
vim.o.ic        = true      -- ignorecase
vim.o.lbr       = true      -- linebreak
vim.o.nu        = true      -- number
vim.o.rnu       = true      -- relativenumber
vim.o.scl       = 'yes'     -- signcolumn
vim.o.scs       = true      -- smartcase
vim.o.so        = 8         -- scrolloff
vim.o.stal      = 0         -- showtabline
vim.o.sts       = 2         -- softtabstop
vim.o.sw        = 2         -- shiftwidth
vim.o.swf       = false     -- swapfile
vim.o.tgc       = true      -- termguicolors
vim.o.ts        = 8         -- tabstop
vim.o.tw        = 0         -- textwidth
vim.o.udf       = true      -- undofile
vim.o.wm        = 0         -- wrapmargin
vim.o.wrap      = true      -- wrap
vim.o.winborder = 'rounded' -- winborder

vim.diagnostic.config({underline = true, virtual_text = { current_line = true, }})

-- PLUGINS
vim.pack.add({
   { src = 'https://github.com/saghen/blink.cmp', version = 'v1.6.0' },
   { src = 'https://github.com/mhartington/formatter.nvim' },
   { src = 'https://github.com/rafamadriz/friendly-snippets' },
   { src = 'https://github.com/slugbyte/lackluster.nvim' },
   { src = 'https://github.com/ggandor/leap.nvim' },
   { src = 'https://github.com/echasnovski/mini.nvim.git' },
   { src = 'https://github.com/neovim/nvim-lspconfig' },
   { src = 'https://github.com/chrisgrieser/nvim-origami' },
   { src = "https://github.com/tpope/vim-obsession.git" },
   { src = "https://github.com/stevearc/oil.nvim.git" },
   { src = "https://github.com/lervag/vimtex" },
   { src = "https://github.com/mbbill/undotree" },
})

require('formatter').setup({
  filetype = {
    c     = { require('formatter.filetypes.c')    .clangformat, },
    cpp   = { require('formatter.filetypes.cpp')  .clangformat, },
    ocaml = { require('formatter.filetypes.ocaml').ocamlformat, },
    latex = { require('formatter.filetypes.latex').ocamlformat, },
    ['*'] = { require('formatter.filetypes.any')  .remove_trailing_whitespace, },
  },
})

require('mini.align')      .setup()
require('mini.diff')       .setup()
require('mini.icons')      .setup()
require('mini.indentscope').setup()
require('mini.git')        .setup()
require('mini.pick')       .setup()
require('mini.statusline') .setup({
  content = {
    active =
      function()
        local mode, mode_hl = MiniStatusline.section_mode       ({ trunc_width = 100 })
        local git           = MiniStatusline.section_git        ({ trunc_width = 40 })
        local diff          = MiniStatusline.section_diff       ({ trunc_width = 75 })
        local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75, signs = { ERROR = 'E', WARN = 'W', INFO = 'I', HINT = 'H' }})
        local filename      = MiniStatusline.section_filename   ({ trunc_width = 1000 })
        local location      = MiniStatusline.section_location   ({ trunc_width = 1000 })
        local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl,   strings = { mode } },
          { hl = 'ModeMsg', strings = { git, diff } },
          '%<', -- Mark general truncate point
          '%=', -- End left alignment
          { hl = 'ModeMsg', strings = { vim.api.nvim_eval([[ObsessionStatus()]]), diagnostics, filename, search, location } },
        })
      end,
    inactive =
      function()
        local git           = MiniStatusline.section_git        ({ trunc_width = 1000 })
        local diff          = MiniStatusline.section_diff       ({ trunc_width = 1000 })
        local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75, signs = { ERROR = 'E', WARN = 'W', INFO = 'I', HINT = 'H' }})
        local filename      = MiniStatusline.section_filename   ({ trunc_width = 140 })
        local location      = MiniStatusline.section_location   ({ trunc_width = 1000 })

        return MiniStatusline.combine_groups({
          { hl = 'ModeMsg', strings = { git, diff } },
          '%<', -- Mark general truncate point
          '%=', -- End left alignment
          { hl = 'ModeMsg', strings = { filename, diagnostics, location } },
        })
      end,
  },
  use_icons = true,
})

require('oil').setup({
  keymaps = {
    [''] = { 'actions.close', mode = 'n' },
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    preview_split = 'right',
  },
})

require('origami').setup()

vim.g.undotree_WindowLayout = 3

vim.g.vimtex_view_general_viewer = 'open'

-- LSP
vim.lsp.enable('clangd')
vim.lsp.enable('elp')
vim.lsp.enable('lua_ls')
vim.lsp.enable('texlab')
vim.lsp.enable('ocamllsp')

require('blink.cmp').setup({
  keymap = {
    ['<C-e>'] = { 'select_prev', 'fallback' },
    ['<Tab>'] = { 'accept' },
  },
  completion = {
    documentation = { auto_show = true },
    ghost_text = { enabled = false }
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })

-- COLOURS
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({})
  end,
})

vim.cmd('colorscheme default')

-- vim.cmd('hi BlinkCmpMenuBorder guibg=NONE')
-- vim.cmd('hi MiniPickPrompt     guibg=NONE')
-- vim.cmd('hi @comment           guifg=#7a7a7a')
-- vim.cmd('hi Comment            guifg=#7a7a7a')
vim.cmd('hi FloatBorder        guibg=NONE')
vim.cmd('hi FloatTitle         guibg=NONE')
vim.cmd('hi FloatFooter        guibg=NONE')
-- vim.cmd('hi MsgArea            guibg=NONE')
vim.cmd('hi Normal             guibg=NONE')
vim.cmd('hi NormalFloat        guibg=NONE')
-- vim.cmd('hi Pmenu              guifg=NONE    guibg=NONE')
-- vim.cmd('hi PmenuKind          guifg=#54546d')
-- vim.cmd('hi PmenuKindSel       guifg=#54546d')
-- vim.cmd('hi PmenuExtra         guibg=NONE')
-- vim.cmd('hi SignColumn         guibg=NONE')
vim.cmd('hi StatusLine         guifg=NONE    guibg=NONE')
vim.cmd('hi StatusLineNC       guibg=NONE')

-- KEYMAPS
vim.g.mapleader = ' '

vim.keymap.set({'n'}, '<leader>q',  ':update<CR>:q<CR>',                    { desc = 'Quit' })
vim.keymap.set({'n'}, '<leader>w',  ':w<CR>',                               { desc = 'Write' })
vim.keymap.set({'n'}, '<leader>r',  ':so ~/.config/nvim/init.lua<CR>',      { desc = 'Source config' })

vim.keymap.set({'n'}, '<leader>d',  vim.diagnostic.open_float,              { desc = 'Show diagnostics' })
vim.keymap.set({'n'}, '<leader>h',  vim.lsp.buf.hover,                      { desc = 'Show documentation' })

vim.keymap.set({'n'}, '<leader>a',  ':noh<CR>',                             { desc = 'Clear search' })

vim.keymap.set({'n'}, '<leader>f',  ':FormatWrite<CR>',                     { desc = 'Format' })

vim.keymap.set({'n'}, '<leader>o',  ':lua require("oil").open_float()<CR>', { desc = 'Explorer' })

vim.keymap.set({'n'}, '<leader> ',  ':Pick buffers<CR>',                    { desc = 'Find buffer' })
vim.keymap.set({'n'}, '<leader>.',  ':Pick help<CR>',                       { desc = 'Find help' })
vim.keymap.set({'n'}, '<leader>>',  ':Pick resume<CR>',                     { desc = 'Continue search' })
vim.keymap.set({'n'}, '<leader>/',  ':Pick files<CR>',                      { desc = 'Find file' })
vim.keymap.set({'n'}, '<leader>?',  ':Pick grep_live<CR>',                  { desc = 'Grep file' })

vim.keymap.set({'n','x','o'}, 's',  '<Plug>(leap)')
vim.keymap.set({'n'}, 'S',          function() require('leap.remote').action() end)

vim.keymap.set({'n'}, '<leader>s',  ':Obsession<CR>',                       { desc = 'Toggle obsession' })

vim.keymap.set({'n'}, '<leader>u',  vim.cmd.UndotreeToggle,                 { desc = 'Undotree' })

vim.keymap.set({'n'}, '<leader>ll', ':VimtexCompile<CR>',                   { desc = 'Compile LaTeX' })
vim.keymap.set({'n'}, '<leader>lv', ':VimtexView<CR>',                      { desc = 'View LaTeX' })

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.cmd.nnoremap('<',     '<')
vim.cmd.nnoremap('>',     '>')
vim.cmd.vnoremap('<',     '<gv')
vim.cmd.vnoremap('>',     '>gv')
vim.cmd.noremap ('#',     '#zz')
vim.cmd.noremap ('*',     '*zz')
vim.cmd.noremap ('<C-d>', '<C-d>zz')
vim.cmd.noremap ('<C-i>', '<C-i>zz')
vim.cmd.noremap ('<C-o>', '<C-o>zz')
vim.cmd.noremap ('<C-u>', '<C-u>zz')
vim.cmd.noremap ('<C-e>', '<C-p>')
vim.cmd.noremap ('<C-p>', '<C-e>')

local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Windows
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),

      -- LaTeX
      { mode = 'n', keys = '<Leader>l', desc = 'LaTeX+' },
    },

    window = {
      delay = 250,
    },
  })
