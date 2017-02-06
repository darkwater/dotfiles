""""""""""""
"" Darkwater's Neovim configuration
"" https://github.com/Darkwater/dotfiles
""
"" Evolved from snippets of other people's configs,
"" probably mostly unique by now.
""

call plug#begin()

" UI plugins
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'majutsushi/tagbar',   { 'on': 'Tagbar'   }
Plug 'mhinz/vim-startify'

" Git helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Format/syntax helpers
Plug 'tpope/vim-commentary'
Plug 'benekastah/neomake'
Plug 'godlygeek/tabular'

" Specific language enhancers
Plug 'idanarye/vim-dutyl',   { 'for': 'd'   }
Plug 'lervag/vimtex',        { 'for': 'tex' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" Miscellaneous shit
Plug 'vim-scripts/JavaDecompiler.vim'
Plug 'moll/vim-bbye'
Plug 'danchoi/ri.vim'

" Extra syntax support
Plug 'hail2u/vim-css3-syntax'
Plug 'dag/vim-fish'
Plug 'tikhomirov/vim-glsl'
Plug 'tfnico/vim-gradle'
Plug 'othree/html5.vim'
Plug 'groenewege/vim-less'
Plug 'derekwyatt/vim-scala'
Plug 'Darkwater/kotlin-vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" Plug '~/projects/agitated/'

call plug#end()


""""""""""""""""""""
"" Settings
""

set cursorline
set hidden
set hlsearch
set ignorecase
set incsearch
set list
set number
set ruler
set showcmd
set noshowmode
set smartcase
set splitbelow
set splitright
set termguicolors
set title
set undofile
set wildmenu
set wrap

set background=dark
set backspace=start,eol,indent
set completeopt=menu,menuone,longest,noselect
set encoding=utf8
set fillchars+=vert:/
set foldcolumn=1
set foldmethod=marker
set history=1000
set laststatus=0
set listchars+=nbsp:%
set listchars+=tab:]-
set listchars+=trail:#
set mouse=a
set numberwidth=5
set pastetoggle=<F11>
set scrolloff=5
set showtabline=2
set tabline=%!CustomTabLine()
set tags+=.tags
set textwidth=120
set timeoutlen=400
set undolevels=1000
set updatetime=1500
set viewoptions=cursor,folds
set wildchar=<Tab>
set wildmode=longest,list
set winminwidth=20
set winwidth=80

" Indentation
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4

colors tomorrow-night
syntax on
filetype plugin indent on


"""""""""""""""""""""""""
"" Plugin configuration
""

" Neovim (I know)
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Racer
let g:racer_experimental_completer = 1

" NERDTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

" Gitgutter
let g:gitgutter_sign_added            = '--'
let g:gitgutter_sign_modified         = '--'
let g:gitgutter_sign_modified_removed = '__'
let g:gitgutter_sign_removed          = '__'

" Neomake
let g:neomake_error_sign  = { 'text': ' ❯', 'texthl': 'ErrorMsg' }
let g:neomake_open_list   = 2 " Preserve cursor position when window is opened
let g:neomake_list_height = 5

" CtrlP
let g:ctrlp_cmd = 'CtrlPCurWD'

" Startify
let g:startify_disable_at_vimenter = 0

let g:startify_default_custom_header = [ '                      -`                     ',
                                       \ '                     .o+`                    ',
                                       \ '                    `ooo/                    ',
                                       \ '                   `+oooo:                   ',
                                       \ '                  `+oooooo:                  ',
                                       \ '                  -+oooooo+:                 ',
                                       \ '                `/:-:++oooo+:                ',
                                       \ '               `/++++/+++++++:               ',
                                       \ '              `/++++++++++++++:              ',
                                       \ '             `/+++ooooooooooooo/`            ',
                                       \ '            ./ooosssso++osssssso+`           ',
                                       \ '           .oossssso-````/ossssss+`          ',
                                       \ '          -osssssso.      :ssssssso.         ',
                                       \ '         :osssssss/        osssso+++.        ',
                                       \ '        /ossssssss/        +ssssooo/-        ',
                                       \ '      `/ossssso+/:-        -:/+osssso+-      ',
                                       \ '     `+sso+:-`                 `.-/+oso:     ',
                                       \ '    `++:.                           `-/+/    ',
                                       \ '    .`                                 `/    ',
                                       \ '',
                                       \ '',
                                       \ '' ]

let g:startify_custom_header = g:startify_default_custom_header

let g:dark_config_files = [ [ 'sx', 'dotfiles/.config/sxhkd/sxhkdrc', 'Config: sxhkd' ],
                          \ [ 'bs', 'dotfiles/.config/bspwm/bspwmrc', 'Config: bspwm' ],
                          \ [ 'zs', 'dotfiles/.zshrc',                'Config: zsh'   ] ]

let g:startify_transformations = map(copy(g:dark_config_files), '[ v:val[1], v:val[2] ]')
let g:startify_bookmarks       = map(copy(g:dark_config_files), '{ v:val[0]: v:val[1] }')

let g:startify_bookmarks += [ { '  ': '' },
                            \ { 'pd': '~/dotfiles/' } ]

let g:startify_change_to_dir      = 0
let g:startify_change_to_vcs_root = 1
let g:startify_files_number       = 20

let g:startify_list_order = [ [ '  Sessions' ],
                            \ 'sessions',
                            \ [ '  Bookmarks' ],
                            \ 'bookmarks',
                            \ [ '  MRU ' . getcwd() ],
                            \ 'dir' ]

hi StartifyBracket ctermfg=0 cterm=bold
hi StartifyHeader  ctermfg=195
hi StartifyFile    ctermfg=9 cterm=bold

" Vimtex
let g:tex_flavor = 'latex'
let g:vimtex_enabled = 1


"""""""""""""
"" Autocmds
""

augroup Vimrc

    autocmd!

    " Cursor line highlighting in ruby is slow as hell :<
    autocmd BufNewFile,BufRead,BufEnter *.rb set nocursorline

    " Automatic syntax checking
    " autocmd BufReadPost,BufEnter,BufWritePost * Neomake

    " Automatically save and load view data (cursor position, folds...)
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview

    " Show Startify when opening a directory
    autocmd VimEnter          * silent! autocmd! FileExplorer
    autocmd VimEnter,BufEnter * call OpenStartifyInDirectory(expand('<amatch>'))

    " Environment-specific settings
    autocmd BufReadPost,BufNewFile * call SetupEnvironment()

augroup end


"""""""""""""
"" Mappings
""

" Fix delete in st
map <F1> <Del>

" ^S for save
nnoremap    <silent> <C-s>      :w<CR>
vnoremap    <silent> <C-s>      <C-c>:w<CR>
inoremap    <silent> <C-s>      <C-c>:w<CR>

" ^J/^K for tab switching
nnoremap    <silent> <C-k>      :bn<CR>
nnoremap    <silent> <C-j>      :bp<CR>

" ^X to close the current buffer
nnoremap    <silent> <C-x>      :Bdelete<CR>
vnoremap    <silent> <C-x>      <C-c>:Bdelete<CR>

" <Home> ignores leading whitespace
nnoremap    <silent> <Home>     ^
vnoremap    <silent> <Home>     ^
inoremap    <silent> <Home>     <C-o>^

" ^G to jump to a tag
nnoremap             <C-g>      :tselect /\C^
vnoremap             <C-g>      <C-c>:tselect /\C^
inoremap             <C-g>      <C-c>:tselect /\C^

" Easily jump to command line
nnoremap    <silent> \          :
vnoremap    <silent> \          :

" Tab for autocompletion
inoremap    <expr>   <Tab>      InsertTabWrapper()
inoremap    <silent> <S-Tab>    <C-p>

" Make Y consistent with D and C
nnoremap    <silent> Y          y$

" Navigate through quickfix list
nnoremap    <silent> [q         :cp<CR>
nnoremap    <silent> ]q         :cn<CR>

" Remove hlsearch
nnoremap    <silent> <BS>       :nohlsearch<CR>

nnoremap    <silent> <Tab>      <C-w><C-w>


""""""""""""""""""""
"" Leader mappings
""

let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Build with make by default
nnoremap          <leader><leader> :nnoremap <silent> <LT>leader><LT>leader> :!

" Startify
nnoremap <silent> <leader>s  :Startify<CR>

" Devdocs
nnoremap <silent> <leader>dd :call jobstart(['chromium-app', 'http://devdocs.io/' . &filetype])<CR>

" File operations
nnoremap <silent> <leader>fd :!rm %<CR>
nnoremap <silent> <leader>fr :call RenameFile()<CR>

" Generate tags
nnoremap <silent> <leader>gt :call jobstart(['ctags', '-R', '.'])<CR>

" Markdown
nnoremap <silent> <leader>mp :call jobstart(['md', expand('%')])<CR>

nnoremap <silent> <leader>vh :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
            \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
            \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


""""""""""""""""""""""""
"" File transforms
""

augroup Binary

    autocmd!

    autocmd BufReadPre   *.bin let &bin=1

    autocmd BufReadPost  *.bin if &bin | %!xxd
    autocmd BufReadPost  *.bin set ft=xxd | endif

    autocmd BufWritePre  *.bin if &bin | %!xxd -r
    autocmd BufWritePre  *.bin endif

    autocmd BufWritePost *.bin if &bin | %!xxd
    autocmd BufWritePost *.bin set nomod | endif

augroup end


""""""""""""""
"" Functions
""

" Custom tab line function
function! CustomTabLine()
    let s = '%#TabLine# '

    let numtabs = tabpagenr('$')
    if numtabs > 1
        let s .= numtabs . ' tabs! (Only one supported) '
    endif

    let listedbufs = {}
    let listedbufi = 1

    for n in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        let listedbufs[n] = listedbufi
        let listedbufi += 1

        " TODO: Handle cases > 9

        let bufname  = substitute(bufname(n), $HOME, '~', '')
        let dirpath  = substitute(bufname, '[^/]\+/\?$', '', '')
        let filename = strpart(bufname, strlen(dirpath))

        let hilight     = (n == bufnr('')) ? '%#TabLineActive#'     : '%#TabLineInactive#'
        let hilightbold = (n == bufnr('')) ? '%#TabLineActiveBold#' : '%#TabLineInactiveBold#'

        let leftbound  = ''
        let rightbound = '  '

        let indicator = (getbufvar(n, '&modified')) ? '%#TabLineModified#! ' : ''

        let s .= hilightbold . leftbound . indicator . hilight . dirpath . hilightbold . filename . rightbound . '%#TabLine# '
    endfor

    " Set up maps to jump to buffer with Alt + number
    " TODO: This should probably go somewhere else
    if len(listedbufs) > 0
        if has_key(listedbufs, bufnr(''))
            let curbufnr = listedbufs[bufnr('')]
        else
            let curbufnr = 0
        endif

        " Previous buffers
        for n in filter(range(1, bufnr('') - 1), 'buflisted(v:val)')
            let d = curbufnr - listedbufs[n]
            execute 'nnoremap <buffer> <A-' . listedbufs[n] . '> :' . d . 'bp<CR>'
            execute 'inoremap <buffer> <A-' . listedbufs[n] . '> <C-c>:' . d . 'bp<CR>'
        endfor

        " Unmap current
        execute 'nnoremap <buffer> <A-' . curbufnr . '> <Nop>'
        execute 'inoremap <buffer> <A-' . curbufnr . '> <Nop>'

        " Next buffers
        for n in filter(range(bufnr('') + 1, bufnr('$')), 'buflisted(v:val)')
            let d = listedbufs[n] - curbufnr
            execute 'nnoremap <buffer> <A-' . listedbufs[n] . '> :' . d . 'bn<CR>'
            execute 'inoremap <buffer> <A-' . listedbufs[n] . '> <C-c>:' . d . 'bn<CR>'
        endfor
    endif

    return s
endfunction


" Tab completion when appropiate
function! InsertTabWrapper()
    if pumvisible()
        return "\<C-n>"
    endif

    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\S'
        return "\<Tab>"
    else
        return &omnifunc == '' ? "\<C-n>" : "\<C-x>\<C-o>"
    endif
endfunction


" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        edit #
        Bdelete
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction


" Run Startify when opening a directory
function! OpenStartifyInDirectory(dir)
    if a:dir != '' && isdirectory(a:dir)
        cd `=a:dir`

        let g:startify_list_order = [ [ '  MRU ' . getcwd() ],
                                    \ 'dir',
                                    \ [ '  Bookmarks' ],
                                    \ 'bookmarks',
                                    \ [ '  Sessions' ],
                                    \ 'sessions' ]

        if isdirectory('.git')
            let g:startify_custom_header = map(split(system('git status -b'), '\n'), '"  ". v:val')
                                       \ + [ '' ]
                                       \ + [ '' ]
        else
            let g:startify_custom_header = g:startify_default_custom_header
        endif

        Bdelete
        Startify
    endif
endfunction


" Environment-specific settings
function! SetupEnvironment()

    if filereadable('build.gradle')

        let &makeprg='./gradlew --daemon'
        let &errorformat='%.%#%t:\ ' . getcwd() . '/%f:\ (%l\,\ %c):\ %m'
        nnoremap <leader><leader> :make installDebug<CR>

        let g:ctrlp_custom_ignore = '\v/(build|cache|gradle)/'

    endif

    if filereadable('dub.sdl') || filereadable('dub.json')

        let &makeprg='dub'
        let &errorformat='%f(%l\,%c):\ Error:\ %m'
        nnoremap <leader><leader> :make<CR>

    endif

    if &filetype == 'ruby'
        set path+=lib
    endif

    if &filetype == 'gitcommit'
        set tw=80
    endif

    if exists("*SetupEnvironmentLocal")
        call SetupEnvironmentLocal()
    end

endfunction


""""""""""""""""""
"" Local rc file
""

if filereadable($HOME . "/.nvimenv")
    source $HOME/.nvimenv
endif

" Example local settings:
"
" function! SetupEnvironmentLocal() ... endfunction
" let g:startify_bookmarks += [ { 'xx': '~/projects/xxxxxxxx/' } ]
"
" vim: ft=vim
