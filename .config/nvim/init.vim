if $USER != "root"
    call plug#begin()

    Plug 'tpope/vim-characterize' " better ga
    Plug 'tpope/vim-commentary'   " toggle comments with gc
    Plug 'tpope/vim-repeat'       " more support for .
    Plug 'tpope/vim-rsi'          " readline-style insertion
    Plug 'tpope/vim-surround'     " surround with pairs
    Plug 'godlygeek/tabular'      " tabularize code

    if !exists("g:vscode")
        Plug 'nvim-treesitter/nvim-treesitter'
        Plug 'nvim-treesitter/nvim-treesitter-textobjects'
        Plug 'folke/which-key.nvim'
        Plug 'github/copilot.vim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'stevearc/dressing.nvim' " optional for vim.ui.select
        Plug 'akinsho/flutter-tools.nvim'
        Plug 'nvchad/nvterm'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'lewis6991/gitsigns.nvim'
        Plug 'MunifTanjim/nui.nvim',
        Plug 'nvim-neo-tree/neo-tree.nvim'
        Plug 'Shatur/neovim-ayu'
        Plug 'rcarriga/nvim-notify'
        Plug 'neovim/nvim-lspconfig'
        Plug 'nvim-orgmode/orgmode'
    endif

    call plug#end()
endif

nmap <Space>ss :call <SID>SynStack()<CR>
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
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <C-c>:<C-u>w<CR>

" fix these keys
nnoremap Y  y$
nnoremap gg gg0
nnoremap G  G0
nnoremap <C-l> :<C-u>noh<CR><C-l>

inoremap <Up>   <C-g><Up>
inoremap <Down> <C-g><Down>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

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
set nohidden

" completion
set wildmenu

" display
set cursorline
set list
set wrap
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

if exists("g:vscode")
    nnoremap gr <Cmd>call VSCodeNotify("editor.action.rename")<CR>
    nnoremap gt <Cmd>call VSCodeNotify("editor.action.goToTypeDefinition")<CR>
    nnoremap z. <Cmd>call VSCodeNotify("editor.action.autoFix")<CR>

    nnoremap <Space>  <Cmd>call VSCodeNotify("whichkey.show")<CR>

    nnoremap gf <Cmd>e <cWORD><CR>
elseif $USER != "root"
    lua require("orgmode").setup_ts_grammar()

    lua require "config.treesitter"

    lua require "config.colors"
    lua require "config.dressing"
    lua require "config.flutter"
    lua require "config.git"
    lua require "config.keybinds"
    lua require "config.lsp"
    lua require "config.neotree"
    lua require "config.orgmode"
    lua require "config.telescope"
    lua require "config.terminal"
    lua require "config.title"
endif
