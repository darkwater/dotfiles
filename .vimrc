if &shell =~# 'fish$'
    set shell=bash
endif

filetype off " Pathogen needs to run before plugin indent on
call pathogen#incubate()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on

set laststatus=0
set timeoutlen=400
set showtabline=2
set encoding=utf8
set pastetoggle=<F11>
set mouse=a
set scrolloff=10
set winwidth=80
set winminwidth=20
set updatetime=1500

" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = '|'
" let g:airline_right_sep = ' '
" let g:airline_right_alt_sep = '│'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = ''
" let g:airline_symbols.paste = ''
" let g:airline_symbols.whitespace = 'Ξ'
" let g:airline_powerline_fonts=0
" let g:airline#extensions#tabline#enabled=1

set go=agit
set gfn=Droid\ Sans\ Mono

set splitbelow
set splitright

set list
"set lcs=eol:,tab:-,trail:·
set lcs=tab:\ \ ,trail:·

let NERDTreeChDirMode=3
let NERDTreeIgnore=['.hex$', '.lst$', '\~$']
"autocmd vimenter * if !argc() && !has('gui_running') | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/glm
set tags+=~/.vim/tags/glfw
set tags+=~/.vim/tags/sdl2
set tags+=~/.vim/tags/enet

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1      " autocomplete after .
let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
let OmniCpp_MayCompleteScope = 1    " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

let g:syntastic_cpp_compiler_options = '-std=c++11'

au BufWritePost *.cpp,*.h SyntasticCheck


if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif


" Ctrl+S for save
nnoremap    <silent> <C-s>      :write<CR>
vnoremap    <silent> <C-s>      <C-O>:write<CR>
inoremap    <silent> <C-s>      <C-O>:write<CR>

" Ctrl+Up/Down for tab switching
nnoremap    <silent> <C-Down>   :bn<CR>
nnoremap    <silent> <C-k>      :bn<CR>
inoremap    <silent> <C-Down>   <C-O>:bn<CR>
nnoremap    <silent> <C-Up>     :bp<CR>
nnoremap    <silent> <C-j>      :bp<CR>
inoremap    <silent> <C-Up>     <C-O>:bp<CR>

" Ctrl+X to close the current buffer
nnoremap    <silent> <C-X>      :bp<bar>sp<bar>bn<bar>bd<CR>
vnoremap    <silent> <C-X>      <C-c>:bp<bar>sp<bar>bn<bar>bd<CR>

inoremap    <silent> <A-h>      <Left>
inoremap    <silent> <A-j>      <Down>
inoremap    <silent> <A-k>      <Up>
inoremap    <silent> <A-l>      <Right>

nnoremap    <silent> <Home>     ^
inoremap    <silent> <Home>     <C-o>^

nnoremap    <silent> <C-g>      :tag /^
vnoremap    <silent> <C-g>      <C-c>:tag /^
inoremap    <silent> <C-g>      <C-c>:tag /^

nnoremap ; :
vnoremap ; :
nnoremap ;; :
vnoremap ;; :
inoremap ;; <C-C>:

"" Ctrl+X for quit
"noremap  <silent> <C-X>         :q<CR>
"inoremap <silent> <C-X>         <C-O>:q<CR>


" Open header files in a vsplit
function SplitHeader()
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


let mapleader = ","

" Android
nnoremap <leader>ad :silent ConqueTermVSplit ant debug install<CR>

" C/C++
nnoremap <leader>ch :call SplitHeader()<CR>
nnoremap <leader>ct :let x = system('ctags -R --language-force=C++ --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .')<CR>

" Java
nnoremap <leader>ji :JavaImport<CR>
nnoremap <leader>js :JavaSearch<CR>
nnoremap <leader>jt :let x = system('ctags -R --language-force=java --sort=yes --fields=+iaS --extra=+q .')<CR>

" Project
nnoremap <leader>pp :ProjectProblems!<CR>

" Comments
nnoremap <leader>// :s/^/\1\/\//<CR>
vnoremap <leader>// :s/^/\1\/\//<CR>
nnoremap <leader>\\ :s/^\( *\)\/\//\1/<CR>
vnoremap <leader>\\ :s/^\( *\)\/\//\1/<CR>


let g:tagbar_type_less = {
\ 'ctagstype' : 'Less',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 'i:identities',
        \ 't:tags',
        \ 'm:medias',
        \ 'v:variables'
    \ ]
\ }

set wildmenu
set wildmode=longest,list

" Wrap too long lines
set wrap

" Tabs are 4 characters
set tabstop=4

" (Auto)indent uses 2 characters
set shiftwidth=4

" spaces instead of tabs
set expandtab

" guess indentation
set autoindent

" Expand the command line using tab
set wildchar=<Tab>

" show line numbers
set number

" Fold using markers {{{
" like this
" }}}
set foldmethod=marker
set foldcolumn=1

" enable all features
set nocompatible

" needs to be called after setting nocompatible
set showmode

" powerful backspaces
set backspace=start,eol,indent

" highlight the searchterms
"set hlsearch

" jump to the matches while typing
set incsearch

" ignore case while searching
set ignorecase

" don't wrap words
set textwidth=0

" history
set history=50

" 1000 undo levels
set undolevels=1000

" show a ruler
set ruler

" show partial commands
set showcmd

" show matching braces
set showmatch

" write before hiding a buffer
set autowrite

" allows hidden buffers to stay unsaved, but we do not want this, so comment
" it out:
set hidden

"set wmh=0

" syntax highlight
syntax on

" we use a dark background, don't we?
set bg=dark

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

set tabline=%!MyTabLine()
function MyTabLine()
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

function MyTabLabel(n)
  let s = ''
  let buflen = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  if buflen > 1
    let s .= '[' . buflen . '] '
  endif
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  if &modified
    let s .= '! '
  endif
  let s .= bufname(buflist[winnr - 1])
  return s
endfunction

colors Tomorrow-Night
