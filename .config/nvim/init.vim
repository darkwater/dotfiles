if $USER != "root"
    call plug#begin()

    Plug 'tpope/vim-characterize'    " better ga
    Plug 'tpope/vim-commentary'      " toggle comments with gc
    Plug 'tpope/vim-endwise'         " auto-end
    Plug 'tpope/vim-fugitive'        " git
    Plug 'tpope/vim-repeat'          " more support for .
    Plug 'tpope/vim-rsi'             " readline-style insertion
    Plug 'tpope/vim-speeddating'     " increment dates
    Plug 'tpope/vim-surround'        " surround with pairs
    Plug 'godlygeek/tabular'         " tabularize code
    Plug 'AndrewRadev/splitjoin.vim' " split/join lines

    if !exists("g:vscode")
        " Plug 'file:///Users/dark/github/darkwater/flutter.nvim'
        " Plug 'darkwater/flutter.nvim'

        Plug 'MunifTanjim/nui.nvim',
        Plug 'Saecki/crates.nvim'
        Plug 'Shatur/neovim-ayu'
        Plug 'akinsho/flutter-tools.nvim'
        Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
        Plug 'andythigpen/nvim-coverage'
        Plug 'dcampos/cmp-snippy'
        Plug 'dcampos/nvim-snippy'
        Plug 'evanleck/vim-svelte', {'branch': 'main'}
        Plug 'folke/noice.nvim'
        Plug 'folke/trouble.nvim'
        Plug 'folke/which-key.nvim'
        Plug 'github/copilot.vim'
        Plug 'glts/vim-magnum'
        Plug 'glts/vim-radical'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-nvim-lua'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }
        " Plug 'jose-elias-alvarez/null-ls.nvim'
        Plug 'nvimtools/none-ls.nvim'
        Plug 'jparise/vim-graphql'
        Plug 'kevinhwang91/nvim-ufo'
        Plug 'kevinhwang91/promise-async'
        Plug 'lewis6991/gitsigns.nvim'
        Plug 'mrcjkb/rustaceanvim'
        Plug 'darkwater/ferris.nvim'
        Plug 'lvimuser/lsp-inlayhints.nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'nvchad/nvterm'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-lualine/lualine.nvim'
        Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }
        Plug 'nvim-orgmode/orgmode'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'nvim-tree/nvim-web-devicons'
        Plug 'nvim-treesitter/nvim-treesitter'
        Plug 'nvim-treesitter/nvim-treesitter-textobjects'
        Plug 'onsails/lspkind.nvim'
        Plug 'othree/html5.vim'
        Plug 'pangloss/vim-javascript'
        Plug 'phaazon/hop.nvim'
        Plug 'rcarriga/nvim-notify'
        Plug 'stevearc/dressing.nvim' " optional for vim.ui.select
        Plug 'stevearc/overseer.nvim'
        Plug 'tikhomirov/vim-glsl'
        Plug 'pest-parser/pest.vim'
        Plug 'mfussenegger/nvim-dap'
        Plug 'nvim-neotest/nvim-nio'
        Plug 'rcarriga/nvim-dap-ui'
        Plug 'vimoutliner/vimoutliner'
        Plug 'wojciech-kulik/xcodebuild.nvim'
        Plug 's1n7ax/nvim-window-picker'

        if hostname() == "atsushi.local"
            Plug 'ActivityWatch/aw-watcher-vim'
        endif
    endif

    call plug#end()

    autocmd FileType swift setlocal commentstring=//\ %s
endif

if exists("g:neovide")
    nmap <D-v> "+p
    imap <D-v> <C-r>+

    if hostname() == "atsushi.local"
        set guifont=Hack,SauceCodePro\ Nerd\ Font:h14.1
        let g:neovide_fullscreen = v:true
    else
        set guifont=Hack,SauceCodePro\ Nerd\ Font:h10.1
    endif

    let g:neovide_transparency = 0.96
    let g:transparency = 0.96
    let g:neovide_scroll_animation_length = 0.12
    let g:neovide_scroll_animation_far_lines = 500
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_remember_window_size = v:true
    let g:neovide_cursor_animation_length = 0.05
    let g:neovide_cursor_antialiasing = v:false
endif

if !exists("g:vscode")
    autocmd FocusGained * lua f = io.open("/tmp/nvim.pid", "w"); f:write(vim.loop.os_getpid()); f:flush(); f:close()

    let g:copilot_filetypes = {
                \ "votl": v:false,
                \ "markdown": v:false,
                \ }
endif

nmap <Space>S :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

hi link helpExample Constant
hi link helpCommand Constant

" === mappings ===

let g:mapleader = "\<Space>"

" <Ctrl-s> to save
nnoremap <C-s> <Cmd>w<CR>
inoremap <C-s> <C-c><Cmd>w<CR>
nmap <D-s> <C-s>
imap <D-s> <C-s>

" fix these keys
nnoremap Y  y$
nnoremap gg gg0
nnoremap G  G0
nnoremap <C-l> <Cmd>noh<CR><C-l>

inoremap <Up>   <C-g><Up>
inoremap <Down> <C-g><Down>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

tnoremap <S-Space> <Space>

" break the undo sequence after these insert-mode commands
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

nmap <C-/> gcc
vmap <C-/> gc

" === settings ===

" backup
if $USER == "root"
    set nobackup
else
    set backup
    set backupdir=~/.local/share/nvim/backup
endif

" buffers
set hidden

" completion
set wildmenu

" display
set cursorline
set list
set wrap
set showbreak=󱞩
set number
set relativenumber
set scrolloff=5
set showcmd
set showmode
set sidescroll=5
set smartcase

" indentation
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4

" search
set hlsearch
set ignorecase
set incsearch

" tui
set termguicolors
set title

" undo
set undofile
set undolevels=1000

" windows
set splitbelow
set splitright

set background=dark
set backspace=start,eol,indent
set cmdheight=1
set completeopt=menu,longest,noselect,preview
set conceallevel=2
set history=10000
set inccommand=nosplit
set iskeyword=@,48-57,_,192-255
set laststatus=2
set listchars=extends:+,nbsp:%,precedes:+,tab:┃·,trail:░
set mouse=a
set nrformats=bin,hex,octal,alpha
set numberwidth=6
set pastetoggle=<F11>
set pumblend=0
set switchbuf=useopen
set shortmess=filnxtToOFW
set textwidth=0
set tildeop
set timeoutlen=300
set ttimeoutlen=5
set updatetime=400
set viewoptions=cursor
" set wildchar=<Tab>
set wildmode=longest:full
set wildoptions=pum,tagfile
set winblend=0
set winminwidth=8
set winwidth=80

if $USER == "root"
    " make it obvious we're root

    set showtabline=2
    set tabline=%#WarningMsg#%{RootLine()}

    function RootLine()
        let l:leftwidth = &columns / 2 - 3
        let l:s   = repeat("=", l:leftwidth)
        let l:s ..= " root "
        let l:s ..= repeat("=", &columns - l:leftwidth - 6)
        return l:s
    endfunction
endif

nohlsearch

" let g:ayucolor = "mirage"
" colorscheme ayu

if $TERM =~ "^screen"
    set notermguicolors
endif

function! ClearTrailingWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! ClearTrailingWhitespace call ClearTrailingWhitespace()

if exists("g:vscode")
    nnoremap gr <Cmd>call VSCodeNotify("editor.action.rename")<CR>
    nnoremap gt <Cmd>call VSCodeNotify("editor.action.goToTypeDefinition")<CR>
    nnoremap z. <Cmd>call VSCodeNotify("editor.action.autoFix")<CR>

    nnoremap <Space>  <Cmd>call VSCodeNotify("whichkey.show")<CR>

    nnoremap gf <Cmd>e <cWORD><CR>
elseif $USER != "root"
    " lua require("orgmode").setup_ts_grammar()

    lua require "config.treesitter"
    lua require "config.lsp"

    lua require "config.autoformat"
    lua require "config.colors"
    lua require "config.completion"
    lua require "config.dap"
    lua require "config.dressing"
    " lua require "config.executor"
    lua require "config.flutter"
    lua require "config.git"
    lua require "config.hop"
    lua require "config.keybinds"
    lua require "config.neotree"
    lua require "config.noice"
    lua require "config.notify"
    " lua require "config.orgmode"
    lua require "config.overseer"
    lua require "config.roomlang"
    lua require "config.rust"
    lua require "config.snippets"
    lua require "config.statusline"
    lua require "config.telescope"
    lua require "config.terminal"
    lua require "config.title"
    lua require "config.trouble"
    lua require "config.ufo"
    " lua require "config.xcode" -- triggered by <leader>x
endif
