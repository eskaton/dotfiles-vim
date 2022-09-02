" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugins')
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

function! FontSizePlus ()
   let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
   let l:gf_size_whole = l:gf_size_whole + 1
   let l:new_font_size = ' '.l:gf_size_whole
   let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
endfunction

function! FontSizeMinus ()
   let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
   let l:gf_size_whole = l:gf_size_whole - 1
   let l:new_font_size = ' '.l:gf_size_whole
   let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
endfunction

function! ToggleMouse()
   if &mouse == ""
      set mouse=a
   else
      set mouse=""
   endif
endfunction

function! ToggleNumber()
   if (!&relativenumber) && (!&number)
      set number
   elseif (&number)
      set nonumber
      set relativenumber
   elseif (&relativenumber)
      set norelativenumber
   endif
endfunction

function! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  :call cursor(lnum, col)
endfun

function! SetWidth(n)
    let &tabstop=a:n
    let &softtabstop=a:n
    let &shiftwidth=a:n
endfunction

call SetWidth(3)

set nu
set autoindent
set expandtab
set ruler
set spelllang=de_ch
set encoding=utf-8
set hlsearch
set incsearch
set wildignore=*.o,*.class,*.pyc
set guifont=Source\ Code\ Pro\ Medium\ 14

filetype indent on
syntax on

let mapleader = ","
nnoremap <leader><space> :noh<cr>
nnoremap <leader>p :set paste!<cr>
nnoremap <leader>m :call ToggleMouse()<cr>
vnoremap <leader>m :call ToggleMouse()<cr>
nnoremap <leader>n :call ToggleNumber()<cr>
nnoremap <leader>s :source %<cr>
nnoremap <leader>f :call ShowFuncName()<cr>

" expand path in command line, e.g. :e %%/
cabbr <expr> %% expand('%:p:h')
 
colo molokai

hi CursorLine cterm=NONE ctermbg=black ctermfg=white guibg=darkred guifg=white

map gr :grep <cword> %:p:h/*<CR>

command! PrettyXML silent %!xmllint --encode UTF-8 --format -

au FileType make setlocal noexpandtab

au BufNewFile,BufRead *.pc set filetype=c
au BufNewFile,BufRead *.jad set filetype=java
au BufNewFile,BufRead .env set filetype=zsh
au BufNewFile,BufRead .aliases set filetype=zsh
au BufNewFile,BufRead .aliases_loc set filetype=zsh
au BufNewFile,BufRead .funcs set filetype=zsh
au BufNewFile,BufRead .funcs_loc set filetype=zsh
au BufNewFile,BufRead *.py call SetWidth(4)
au BufNewFile,BufRead *.rs call SetWidth(4)

if has("gui_running")
    nmap <S-F12> :call FontSizeMinus()<CR>
    nmap <F12> :call FontSizePlus()<CR>
    set mouse=a
else
    set mouse=""
endif

if has('persistent_undo')
   silent !mkdir -p ~/.cache/vim/undo
   set undofile
   set undodir=~/.cache/vim/undo
endif
