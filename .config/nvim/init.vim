""""""""""""
"" Neovim configuration
"" Assembled by Darkwater
"" 90% stolen from other people
""

call plug#begin()

" UI plugins
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTree' }
Plug 'majutsushi/tagbar',   { 'on': 'Tagbar'   }

" Git helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Format/syntax helpers
Plug 'tpope/vim-commentary'
Plug 'benekastah/neomake'
Plug 'godlygeek/tabular'

" Extra syntax support
Plug 'hail2u/vim-css3-syntax',            { 'for': 'css'    }
Plug 'dag/vim-fish',                      { 'for': 'fish'   }
Plug 'tikhomirov/vim-glsl',               { 'for': 'glsl'   }
Plug 'tfnico/vim-gradle',                 { 'for': 'gradle' }
Plug 'othree/html5.vim',                  { 'for': 'html'   }
Plug 'groenewege/vim-less',               { 'for': 'less'   }
Plug 'derekwyatt/vim-scala',              { 'for': 'scala'  }

call plug#end()


""""""""""""""""""""
"" Set basic stuff
""

set cursorline
set hidden
set nohlsearch
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
set textwidth=80
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

colors Tomorrow-Night
syntax on
filetype plugin indent on


"""""""""""""""""""""""""
"" Plugin configuration
""

let NERDTreeChDirMode=3
let NERDTreeIgnore=['.hex$', '.lst$', '\~$']

let g:gitgutter_sign_added            = '+'
let g:gitgutter_sign_modified         = '~'
let g:gitgutter_sign_modified_removed = '~.'
let g:gitgutter_sign_removed          = '_'

let g:neomake_error_sign = { 'text': ' ❯', 'texthl': 'ErrorMsg' }
let g:neomake_open_list = 2 " Preserve cursor position when window is opened
let g:neomake_list_height = 5

"""""""""""""
"" Autocmds
""

augroup Vimrc

    autocmd!

    " Cursor line highlighting in ruby is slow as hell :<
    autocmd BufNewFile,BufRead,BufEnter *.rb set nocursorline

    autocmd BufReadPost,BufEnter,BufWritePost * Neomake

    autocmd BufWinLeave * mkview
    autocmd BufWinEnter * silent! loadview

augroup end


"""""""""""""
"" Mappings
""

" Fix Ctrl+arrows in urxvt for all modes(???)
map         <silent> Ïa         <C-Up>
map         <silent> Ïb         <C-Down>
map         <silent> Ïc         <C-Right>
map         <silent> Ïd         <C-Left>
map!        <silent> Ïa         <C-Up>
map!        <silent> Ïb         <C-Down>
map!        <silent> Ïc         <C-Right>
map!        <silent> Ïd         <C-Left>

" ^S for save
nnoremap    <silent> <C-s>      :write<CR>
vnoremap    <silent> <C-s>      <C-O>:write<CR>
inoremap    <silent> <C-s>      <C-O>:write<CR>

" ^J/^K for tab switching
nnoremap    <silent> <C-k>      :bn<CR>
nnoremap    <silent> <C-j>      :bp<CR>

" ^X to close the current buffer
nnoremap    <silent> <C-x>      :bp<bar>sp<bar>bn<bar>bd!<CR>
vnoremap    <silent> <C-x>      <C-c>:bp<bar>sp<bar>bn<bar>bd!<CR>

" ^Q for :q!
nnoremap    <silent> <C-q>      :q!<CR>
vnoremap    <silent> <C-q>      <C-c>:q!<CR>

" <Home> ignores leading whitespace
nnoremap    <silent> <Home>     ^
vnoremap    <silent> <Home>     ^
inoremap    <silent> <Home>     <C-o>^

" ^G to jump to a tag
nnoremap    <silent> <C-g>      :tag /^
vnoremap    <silent> <C-g>      <C-c>:tag /^
inoremap    <silent> <C-g>      <C-c>:tag /^

" Easily jump to command line
nnoremap    <silent> ;          :
vnoremap    <silent> ;          :
nnoremap    <silent> ;;         :
vnoremap    <silent> ;;         :
inoremap    <silent> ;;         <C-C>:

" Tab for autocompletion
inoremap    <expr>   <Tab>      InsertTabWrapper()
inoremap    <silent> <S-Tab>    <C-p>

" {}| to {\n|\n} (^Z to undo)
inoremap    <silent> {}         <CR>{<CR>}<Up><CR>
inoremap    <silent> <C-z>      <BS><Down><BS><BS>{}<BS><BS>{}

" Make Y consistent with D and C
nnoremap    <silent> Y          y$

" Use ^E/^Y in insert mode directly
inoremap    <silent> <C-e>      <C-x><C-e>
inoremap    <silent> <C-y>      <C-x><C-y>

" F# for buffer switching
nnoremap    <silent> <F1>       :1b<CR>
inoremap    <silent> <F1>       <C-c>:1b<CR>
let i = 2
while i <= 12
    execute "nnoremap <silent> <F" . i . "> :1b\\|" . (i - 1) . "bn<CR>"
    execute "inoremap <silent> <F" . i . "> <C-c>:1b\\|" . (i - 1) . "bn<CR>"
    let i += 1
endwhile


""""""""""""""""""""
"" Leader mappings
""

let mapleader = ","

" Gradle
nnoremap <leader>gid :!gradle --daemon installDebug<CR>

" C++
nnoremap <leader>ch :call SplitHeader()<CR>
nnoremap <leader>ct :let x = system('ctags -R --language-force=C++ --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .')<CR>

" File
nnoremap <leader>fr :call RenameFile()<CR>

" Shortcuts
nnoremap <leader>gt :terminal<CR>
nnoremap <leader>gr :sp term://./%<CR>a

" Java
nnoremap <leader>jt :let x = system('ctags -R --language-force=Java --sort=yes --fields=+iaS --extra=+q .')<CR>

" Tests
nnoremap <leader>tt :call RunTestFile()<cr>
nnoremap <leader>tn :call RunNearestTest()<cr>
nnoremap <leader>ta :call RunTests('')<cr>

""""""""""""""""""""""""
"" Binary file editing
""
augroup Binary

    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif

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


""""""""""""""""""
"" Local rc file
""

if filereadable("./.vimlocalrc")
    source ./.vimlocalrc
endif
