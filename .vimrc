" =========== deni.vim settings ===========
if &compatible
  set nocompatible
endif

" install dir
let s:dein_dir = expand('~/.cache/dein') 
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein installation check
if &runtimepath !~# '/dein.vim'
 if !isdirectory(s:dein_repo_dir)
 execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
 endif
 execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" begin settings
if dein#load_state(s:dein_dir)
 call dein#begin(s:dein_dir)

 " .toml file
 let s:rc_dir = expand('~/.vim/dein') 
 let s:toml = s:rc_dir . '/dein.toml'
 let s:lazy_toml = s:rc_dir . '/dein_lazy.toml' 

 " read toml and cache
 call dein#load_toml(s:toml, {'lazy': 0})
 call dein#load_toml(s:lazy_toml, {'lazy': 1}) 

 " end settings
 call dein#end()
 call dein#save_state()
endif

" plugin installation check
if dein#check_install()
 call dein#install()
endif

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}

" add molokai
call dein#add('tomasr/molokai')
colorscheme molokai

" =========================================

"Character code
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"Syntax highlighting
syntax enable

"Color scheme
colorscheme molokai

"Filetype plugin
filetype plugin indent on

"Cursorline
set cursorline

"Row number
set number

"Search
set hlsearch "highliting results
set ignorecase "ignore capital and small
set incsearch "highliting pattern matching

"Save undo history
if has('persistent_undo')
    let undo_path = expand('~/.vim/undo')
    if !isdirectory(undo_path)
       call mkdir(undo_path, 'p')
    endif
    let &undodir = undo_path
    set undofile
endif

"Tab Key
set tabstop=4 "number of spaces
set expandtab

"Indent
set smartindent
set shiftwidth=4 "number of spaces for indent

"Clipboard
set clipboard+=unnamed

"Status line
set laststatus=2

"Short form selection
set virtualedit=block

"Interpolation commandlines
set wildmenu

"Save
nnoremap <C-s> :w<CR> "Save Ctrl+S

"Disable yank with delete
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D

"Cursol
if has('vim_starting')
    let &t_SI .= "\e[6 q" "Insert mode
    let &t_EI .= "\e[2 q" "Normal mode
    let &t_SR .= "\e[4 q" "Replace mode
endif

"Command history
set history=100

"Show command
set showcmd 

"Show the number of matches
set shortmess-=S

"Backspace
set backspace=indent,eol,start

"lanugage
language en_US.UTF-8

"============= tab ===================
"" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " show tabline

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
nmap <Tab>      gt
nmap <S-Tab>    gT

" Tab jump
" Set the target tab number from left side for jumping by 't + number' 
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" 'tc' makes a new tab at rightmost
map <silent> [Tag]c :tablast <bar> tabnew<CR>

" 'tx' closes a current tab
map <silent> [Tag]x :tabclose<CR>

" 'tn' moves to a next tab
map <silent> [Tag]n :tabnext<CR>

" 'tp' move to a previous tab
map <silent> [Tag]p :tabprevious<CR>

" Python execute autopep8 and flake8 with :w
function! Preserve(command)
    " Save the last search.
    let search = @/
    " Save the current cursor position.
    let cursor_position = getpos('.')
    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)
    " Execute the command.
    execute a:command
    " Restore the last search.
    let @/ = search
    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt
    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction

function! Autopep8()
    "--ignote=E501: Ignore completing the length of a line."
    call Preserve(':silent %!autopep8 --ignore=E501 -')
endfunction

augroup python_auto_lint
  autocmd!
  autocmd BufWrite *.py :call Autopep8()
  autocmd BufWritePost *.py call flake8#Flake8()
augroup END

"===================================

"============ plugins ==============

"vim-terraform
let g:terraform_align=1
let g:terraform_fold_sections=0
let g:terraform_fmt_on_save=1

"docker
let g:docker_plugin_version_check = 0

"go-vim
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_autosave = 1
let g:go_highlight_fields = 1
let g:neocomplete#enable_at_startup = 1
