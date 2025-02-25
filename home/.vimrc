
syntax on
set number relativenumber
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
set autoindent smartindent
set list listchars=tab:▸_,trail:·,extends:»,precedes:«,leadmultispace:.
set splitright splitbelow
set nofoldenable foldmethod=indent
set incsearch ignorecase smartcase
set scrolloff=10 sidescrolloff=80
set termguicolors hlsearch nowrap
set iskeyword=@,48-57,_,192-255,- isfname=@,48-57,/,.,-,_,+,,,#,$,%,~,=,@-@
set laststatus=2 showcmd shortmess-=S
set termwinsize=20*10

" KEYMAPS
let g:mapleader=" "
let g:maplocalleader=g:mapleader

nnoremap <silent> <leader>nh :nohl<CR>
nnoremap <silent> <leader>q :bdelete!<CR>
nnoremap <silent> Q :%bdelete\|e#<CR>
nnoremap <silent> <C-s> :wa<CR>
inoremap <silent> <C-s> <ESC>:wa<CR>
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

nnoremap <silent> <leader>y "+y
vnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>p "+p

nnoremap <silent> <leader>rp :%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left> <BS>
nnoremap <silent> <leader>rP :%s/<C-r>0/<C-r>+/gI<Left><Left><Left> <BS>

vnoremap <silent> < <gv
vnoremap <silent> > >gv

nnoremap <silent> <C-\> <CMD>terminal<CR>
nnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k

" Netrw
let g:netrw_bufsettings="noma nomod nu nowrap ro nobl"
nnoremap <silent> <C-e> :Explore<CR>

function! CopyPath()
  let @+ = execute(":echon netrw#Call('NetrwTreeDir', 0)")
  let @+ = @+ .. '/'
  let @+ = @+ .. execute(":echon netrw#Call('NetrwGetWord')")
  echo 'copied path: ' .. @+
endfunction

function! Netrw()
  nmap <silent> <buffer> h -
  nmap <silent> <buffer> l <CR>
  nmap <silent> <buffer> cp :call CopyPath()<CR>
endfunction

autocmd Filetype netrw call Netrw()
autocmd BufNewFile ~/Notes/* execute 'file' fnameescape(expand("%:h") . strftime("/%Y%m%d_" . expand("%:t")))

" undofiles
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Fix cursor in iterm2
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
  autocmd VimLeave * silent !echo -ne "\e[4 q"
endif

" Colorscheme: catppuccin_mocha
colorscheme catppuccin_mocha

" Plugins: vim-highlightedyank
let g:highlightedyank_highlight_duration = 100
highlight HighlightedyankRegion ctermbg=237 guibg=#19c8e6

" Plugins: vim-auto-session

" Plugins: vim-visual-multi
