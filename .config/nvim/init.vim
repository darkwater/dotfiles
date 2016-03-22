""""""""""""
"" Neovim configuration
"" Assembled by Darkwater
"" 50% stolen from other people
""

call plug#begin()

" UI plugins
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'majutsushi/tagbar',   { 'on': 'Tagbar'   }

" Git helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Format/syntax helpers
Plug 'tpope/vim-commentary'
Plug 'benekastah/neomake'
Plug 'godlygeek/tabular'
Plug 'octol/vim-cpp-enhanced-highlight'

" Miscellaneous shit
Plug 'vim-scripts/JavaDecompiler.vim'
Plug 'moll/vim-bbye'
Plug 'mhinz/vim-startify'

" Extra syntax support
Plug 'hail2u/vim-css3-syntax'
Plug 'dag/vim-fish'
Plug 'tikhomirov/vim-glsl'
Plug 'tfnico/vim-gradle'
Plug 'othree/html5.vim'
Plug 'groenewege/vim-less'
Plug 'derekwyatt/vim-scala'
Plug 'udalov/kotlin-vim'

call plug#end()


""""""""""""""""""""
"" Set basic stuff
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
set showmode
set smartcase
set splitbelow
set splitright
set title
set undofile
set wildmenu
set wrap

set backspace=start,eol,indent
set background=dark
set completeopt=menu,preview
set encoding=utf8
set foldcolumn=1
set foldmethod=manual
set history=1000
set laststatus=0
set lcs=tab:··,trail:░,nbsp:%
set mouse=a
set numberwidth=5
set pastetoggle=<F11>
set scrolloff=5
set showtabline=2
set tabline=%!MyTabLine()
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

" Gitgutter
let g:gitgutter_sign_added            = '•'
let g:gitgutter_sign_modified         = '•'
let g:gitgutter_sign_modified_removed = '•'
let g:gitgutter_sign_removed          = '_'
hi GitGutterChangeDelete ctermfg=3 cterm=underline
hi GitGutterDelete       ctermfg=1 cterm=underline

" Neomake
let g:neomake_error_sign  = { 'text': ' ❯', 'texthl': 'ErrorMsg' }
let g:neomake_open_list   = 2 " Preserve cursor position when window is opened
let g:neomake_list_height = 5

" CtrlP
let g:ctrlp_cmd = 'CtrlPCurWD'

" Startify
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

let g:startify_bookmarks = [ { '.c': '~/.config/' },
                           \ { '.j': '~/.js/' },
                           \ { '  ': '' },
                           \ { 've': '~/.nvimenv' },
                           \ { 'vi': '~/.config/nvim/init.vim' },
                           \ { 'vc': '~/.config/nvim/colors/tomorrow-night.vim' },
                           \ { '  ': '' },
                           \ { 'pd': '~/dotfiles/' } ]

let g:startify_change_to_dir      = 0
let g:startify_change_to_vcs_root = 1
let g:startify_files_number       = 20

let g:startify_list_order = [ [ '  Sessions' ],
                            \ 'sessions',
                            \ [ '  Bookmarks' ],
                            \ 'bookmarks',
                            \ [ '  MRU' ],
                            \ 'dir' ]

hi StartifyBracket ctermfg=0 cterm=bold
hi StartifyHeader  ctermfg=195


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

    " Run Startify when opening a directory
    autocmd VimEnter          * silent! autocmd! FileExplorer
    autocmd VimEnter,BufEnter * call OpenStartifyInDirectory(expand('<amatch>'))

augroup end


"""""""""""""
"" Mappings
""

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

" ^Q for :q!
nnoremap    <silent> <C-q>      :q!<CR>
vnoremap    <silent> <C-q>      <C-c>:q!<CR>

" <Home> ignores leading whitespace
nnoremap    <silent> <Home>     ^
vnoremap    <silent> <Home>     ^
inoremap    <silent> <Home>     <C-o>^

" ^G to jump to a tag
nnoremap    <silent> <C-g>      :tag /\C^
vnoremap    <silent> <C-g>      <C-c>:tag /\C^
inoremap    <silent> <C-g>      <C-c>:tag /\C^

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


""""""""""""""""""""
"" Leader mappings
""

let mapleader = "\<Space>"

" Startify
nnoremap <silent> <leader>s  :Startify<CR>

" Terminal
nnoremap <silent> <leader>t  :call jobstart(['urxvtc', '-cd', getcwd()])<CR>

" C++
nnoremap <silent> <leader>ch :call SplitHeader()<CR>

" Devdocs
nnoremap <silent> <leader>dd :call jobstart(['chromium-app', 'http://devdocs.io/' . &filetype])<CR>

" File operations
nnoremap <silent> <leader>fd :!rm %<CR>
nnoremap <silent> <leader>fr :call RenameFile()<CR>

" Generate tags
nnoremap <silent> <leader>gt :call jobstart(['ctags', '-R', '-f.tags', '.'])<CR>

" Markdown
nnoremap <silent> <leader>mp :call jobstart(['md', expand('%')])<CR>


""""""""""""""""""""""""
"" Binary file editing
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

" Run current or last test file
function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.py\)$') != -1
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction


" Run the nearest test
function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction


" Set the spec file that tests will be run for.
function! SetTestFile(command_suffix)
    let t:grb_test_file=@% . a:command_suffix
endfunction


" Write the file and run tests for the given filename
function! RunTests(filename)
    if expand("%") != ""
      :w
    end
    silent! exec ":!echo;echo;echo -e '\e[40m\e[K\e[0m';echo"
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            " First choice: project-specific test script
            exec ":!script/test " . a:filename
        elseif filewritable(".test-commands")
          " Fall back to the .test-commands pipe if available, assuming someone
          " is reading the other side and running the commands
          let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
          exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

          " Write an empty string to block until the command completes
          sleep 100m " milliseconds
          :!echo > .test-commands
          redraw!
        elseif filereadable("Gemfile")
            " Fall back to a blocking test run with Bundler
            exec ":!bundle exec rspec --color " . a:filename
        elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
            " If we see python-looking tests, assume they should be run with Nose
            exec "!nosetests " . a:filename
        else
            " Fall back to a normal blocking test run
            exec ":!rspec --color " . a:filename
        end
    end
endfunction


" Open header files in a vsplit
function! SplitHeader()
    let mainwin = winnr()

    if winnr('$') == 1
        80vsplit
    endif

    let h = expand('%:r').'.h'

    wincmd l
    if winnr() == mainwin
        80vsplit
    endif

    exec 'e '.h
    wincmd p
endfunction


" Custom tab line function
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction


" Custom tab label function
function! MyTabLabel(n)
  let s = ''
  let buflen = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  if buflen > 1
    let s .= len(filter(range(1, bufnr('%')), 'buflisted(v:val)')) . ' / ' . buflen . ' · '
  endif
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  if &modified
    let s .= '! '
  endif
  let s .= bufname(buflist[winnr - 1])
  return s
endfunction


" Tab completion when appropiate
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction


" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
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


""""""""""""""""""
"" Local rc file
""

if filereadable($HOME . "/.nvimenv")
    source $HOME/.nvimenv
endif

" Example template for convenient copypasta:
"
" " Machine-local Neovim configuration
"
" function! SetupEnvironment()
"     let l:path = expand('%:p')
"     if l:path =~ '/home/dark/projects/almanapp-android/'
"
"         let &makeprg='./build.rb'
"         let &errorformat='%A%.%#/home/dark/projects/almanapp-android/%f:%l:\ %m,%-Z%p^,%.%#%t:\ /home/dark/projects/almanapp-android/%f:\ (%l\,\ %c):\ %m,%-G%.%#'
"         nnoremap <leader><leader> :make build debug --run<CR>
"
"         let g:ctrlp_custom_ignore = '\v/(build|cache|gradle)/'
"
"     elseif l:path =~ '/home/dark/projects/aegis/'
"
"         let &makeprg='./gradlew --daemon'
"         let &errorformat='%.%#%t:\ /home/dark/projects/aegis/%f:\ (%l\,\ %c):\ %m,%-G%.%#'
"         nnoremap <leader><leader> :make instalLDebug<CR>
"
"         let g:ctrlp_custom_ignore = '\v/(build|cache|gradle)/'
"
"     endif
" endfunction
"
" augroup SetupEnvironment
"
"     autocmd!
"
"     autocmd BufReadPost,BufNewFile * call SetupEnvironment()
"
" augroup end
"
" let g:startify_bookmarks += [ { 'ag': '~/projects/aegis/build.gradle' } ]
"
" " vim: set ft=vim:
