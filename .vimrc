""""""""""""
"" .vimrc
"" Used by Darkwater
"" 90% stolen from other people
""

call pathogen#incubate()


""""""""""""""""""""
"" Set basic stuff
""

set backspace=start,eol,indent
set background=dark
set completeopt=menu,preview
set encoding=utf8
set foldcolumn=1
set foldmethod=marker
set hidden
set history=1000
set ignorecase
set incsearch
set laststatus=0
set lcs=tab:··,trail:░
set list
set mouse=a
set nocompatible
set number
set pastetoggle=<F11>
set ruler
set scrolloff=5
set showcmd
set showmode
set showtabline=2
set smartcase
set splitbelow
set splitright
set tabline=%!MyTabLine()
set textwidth=0
set timeoutlen=400
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set updatetime=1500
set wildchar=<Tab>
set wildmenu
set wildmode=longest,list
set winminwidth=20
set winwidth=80
set wrap

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

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let g:syntastic_cpp_compiler_options = '-std=c++11'

"""""""""""""
"" Autocmds
""

augroup Vimrc

    autocmd!

    " Use OmniCppComplete for omni completion
    au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

    " Open a file on last known cursor position if valid
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

augroup end


"""""""""""""
"" Mappings
""

" Fix Ctrl+arrows in urxvt for all modes
map         <silent> <ESC>Oa    <C-Up>
map         <silent> <ESC>Ob    <C-Down>
map         <silent> <ESC>Oc    <C-Right>
map         <silent> <ESC>Od    <C-Left>
map!        <silent> <ESC>Oa    <C-Up>
map!        <silent> <ESC>Ob    <C-Down>
map!        <silent> <ESC>Oc    <C-Right>
map!        <silent> <ESC>Od    <C-Left>

" ^S for save
nnoremap    <silent> <C-s>      :write<CR>
vnoremap    <silent> <C-s>      <C-O>:write<CR>
inoremap    <silent> <C-s>      <C-O>:write<CR>

" ^J/^K for tab switching
nnoremap    <silent> <C-k>      :bn<CR>
nnoremap    <silent> <C-j>      :bp<CR>

" ^X to close the current buffer
nnoremap    <silent> <C-X>      :bp<bar>sp<bar>bn<bar>bd<CR>
vnoremap    <silent> <C-X>      <C-c>:bp<bar>sp<bar>bn<bar>bd<CR>

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

" {}| to {\n|\n}
inoremap    <silent> {}         <CR>{<CR>}<Up><CR>

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

" Java
nnoremap <leader>ji :JavaImport<CR>
nnoremap <leader>js :JavaSearch<CR>
nnoremap <leader>jt :let x = system('ctags -R --language-force=Java --sort=yes --fields=+iaS --extra=+q .')<CR>

" Project
nnoremap <leader>pp :ProjectProblems!<CR>

" Comments
nnoremap <leader>// :s/^/\1\/\//<CR>
vnoremap <leader>// :s/^/\1\/\//<CR>
nnoremap <leader>\\ :s/^\( *\)\/\//\1/<CR>
vnoremap <leader>\\ :s/^\( *\)\/\//\1/<CR>
nnoremap <leader>/# :s/^/\1#/<CR>
vnoremap <leader>/# :s/^/\1#/<CR>
nnoremap <leader>\# :s/^\( *\)#/\1/<CR>
vnoremap <leader>\# :s/^\( *\)#/\1/<CR>


"""""""""
"" Less
""

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


"""""""""""
"" Binary
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
