if $USER != "root"
    call plug#begin()

    Plug 'tpope/vim-characterize' " better ga
    Plug 'tpope/vim-commentary'   " toggle comments with gc
    Plug 'tpope/vim-repeat'       " more support for .
    Plug 'tpope/vim-rsi'          " readline-style insertion
    Plug 'tpope/vim-surround'     " surround with pairs
    Plug 'godlygeek/tabular'      " tabularize code

    if !exists("g:vscode")
        Plug 'tpope/vim-surround'
        Plug 'folke/which-key.nvim'
        Plug 'github/copilot.vim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'stevearc/dressing.nvim' " optional for vim.ui.select
        Plug 'akinsho/flutter-tools.nvim'
        Plug 'nvchad/nvterm'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'lewis6991/gitsigns.nvim'
    endif

    call plug#end()
endif

nnoremap K <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap gd <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Space>ca <Cmd>lua vim.lsp.buf.code_action()<CR>
xnoremap <Space>ca <Cmd>lua vim.lsp.buf.range_code_action()<CR>

nmap <F2> :call <SID>SynStack()<CR>
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
inoremap <C-s> <C-o>:<C-u>w<CR>

" fix these keys
nnoremap Y  y$
nnoremap gg gg0
nnoremap G  G0
nnoremap <C-l> <C-l>:noh<CR>

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
set hidden

" completion
set wildmenu

" display
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
set fillchars=fold:\ ,vert:\ ,
set history=10000
set inccommand=nosplit
set iskeyword=@,48-57,_,192-255
set laststatus=2
set listchars=extends:+,nbsp:%,precedes:+,tab:┃·,trail:░
set mouse=a
set nrformats=bin,hex,octal,alpha
set numberwidth=6
set pastetoggle=<F11>
set pumblend=8
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
set winblend=8
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

let g:ayucolor = "mirage"
colorscheme ayu

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
    lua require "config.dressing"
    lua require "config.flutter"
    lua require "config.git"
    lua require "config.keybinds"
    lua require "config.telescope"
    lua require "config.terminal"
endif
