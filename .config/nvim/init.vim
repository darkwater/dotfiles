if $USER != "root"
    call plug#begin()
    Plug 'tpope/vim-characterize' " better ga
    Plug 'tpope/vim-commentary'   " toggle comments with gc
    Plug 'tpope/vim-repeat'       " more support for .
    Plug 'tpope/vim-rsi'          " readline-style insertion
    Plug 'tpope/vim-surround'     " surround with pairs
    Plug 'godlygeek/tabular'      " tabularize code
    call plug#end()
endif

" === mappings ===

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
set nowrap
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
set completeopt=menu,longest,noselect
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
set timeoutlen=800
set ttimeoutlen=5
set updatetime=400
set viewoptions=cursor
" set wildchar=<Tab>
" set wildmode=longest
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

    nnoremap <Space>_  <Cmd>call VSCodeNotify("notifications.showList")<CR>

    nnoremap <Space>wq <Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>
    nnoremap <Space>wQ <Cmd>call VSCodeNotify("workbench.action.closeOtherEditors")<CR>
    nnoremap <Space>w= <Cmd>call VSCodeNotify("workbench.action.evenEditorWidths")<CR>
    nnoremap <Space>wh <Cmd>call VSCodeNotify("workbench.action.focusLeftGroup")<CR>
    nnoremap <Space>wj <Cmd>call VSCodeNotify("workbench.action.focusBelow")<CR>
    nnoremap <Space>wk <Cmd>call VSCodeNotify("workbench.action.focusAboveGroup")<CR>
    nnoremap <Space>wl <Cmd>call VSCodeNotify("workbench.action.focusRightGroup")<CR>
    nnoremap <Space>wH <Cmd>call VSCodeNotify("workbench.action.moveEditorToLeftGroup")<CR>
    nnoremap <Space>wJ <Cmd>call VSCodeNotify("workbench.action.moveEditorToBelowGroup")<CR>
    nnoremap <Space>wK <Cmd>call VSCodeNotify("workbench.action.moveEditorToAboveGroup")<CR>
    nnoremap <Space>wL <Cmd>call VSCodeNotify("workbench.action.moveEditorToRightGroup")<CR>
    nnoremap <Space>w< <Cmd>call VSCodeNotify("workbench.action.moveEditorLeftInGroup")<CR>
    nnoremap <Space>w> <Cmd>call VSCodeNotify("workbench.action.moveEditorRightInGroup")<CR>

    nnoremap <Space>dd <Cmd>call VSCodeNotify("workbench.action.debug.start")<CR>
    nnoremap <Space>dD <Cmd>call VSCodeNotify("workbench.action.debug.run")<CR>
    nnoremap <Space>dc <Cmd>call VSCodeNotify("workbench.action.debug.continue")<CR>
    nnoremap <Space>dC <Cmd>call VSCodeNotify("workbench.action.debug.pause")<CR>
    nnoremap <Space>dr <Cmd>call VSCodeNotify("workbench.action.debug.restart")<CR>
    nnoremap <Space>ds <Cmd>call VSCodeNotify("workbench.action.debug.stop")<CR>
    nnoremap <Space>dS <Cmd>call VSCodeNotify("workbench.action.debug.disconnect")<CR>
    nnoremap <Space>db <Cmd>call VSCodeNotify("editor.debug.action.toggleBreakpoint")<CR>
    nnoremap <Space>dB <Cmd>call VSCodeNotify("editor.debug.action.toggleInlineBreakpoint")<CR>
    nnoremap <Space>di <Cmd>call VSCodeNotify("workbench.action.debug.stepInto")<CR>
    nnoremap <Space>do <Cmd>call VSCodeNotify("workbench.action.debug.stepOver")<CR>
    nnoremap <Space>df <Cmd>call VSCodeNotify("workbench.action.debug.stepOut")<CR>

    nnoremap <Space>gd <Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>
    nnoremap <Space>gD <Cmd>call VSCodeNotify("editor.action.revealDeclaration")<CR>
    nnoremap <Space>ge <Cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>
    nnoremap <Space>gi <Cmd>call VSCodeNotify("editor.action.goToImplementation")<CR>
    nnoremap <Space>gp <Cmd>call VSCodeNotify("editor.action.marker.nextInFiles")<CR>
    nnoremap <Space>gr <Cmd>call VSCodeNotify("editor.action.goToReferences")<CR>
    nnoremap <Space>gs <Cmd>call VSCodeNotify("workbench.action.gotoSymbol")<CR>
    nnoremap <Space>gS <Cmd>call VSCodeNotify("workbench.action.showAllSymbols")<CR>
    nnoremap <Space>gt <Cmd>call VSCodeNotify("editor.action.goToTypeDefinition")<CR>

    nnoremap <Space>v_ <Cmd>call VSCodeNotify("workbench.action.closePanel")<CR>
    nnoremap <Space>ve <Cmd>call VSCodeNotify("workbench.view.explorer")<CR>
    nnoremap <Space>vf <Cmd>call VSCodeNotify("workbench.view.search")<CR>
    nnoremap <Space>vd <Cmd>call VSCodeNotify("workbench.view.debug")<CR>
    nnoremap <Space>vg <Cmd>call VSCodeNotify("workbench.view.scm")<CR>
    nnoremap <Space>vG <Cmd>call VSCodeNotify("git-graph.view")<CR>
    nnoremap <Space>vx <Cmd>call VSCodeNotify("workbench.view.extensions")<CR>
    nnoremap <Space>vo <Cmd>call VSCodeNotify("workbench.action.output.toggleOutput")<CR>
    nnoremap <Space>vp <Cmd>call VSCodeNotify("workbench.panel.markers.view.focus")<CR>
    nnoremap <Space>vy <Cmd>call VSCodeNotify("workbench.panel.repl.view.focus")<CR>
endif
