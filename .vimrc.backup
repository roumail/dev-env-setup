let mapleader=" "
set clipboard+=unnamedplus

" Start plugin installation
call plug#begin('~/.vim/plugged')
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' 
" File directory
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'yuki-yano/fern-mapping-fzf.vim'
Plug 'yuki-yano/fern-preview.vim'
"Plug 'preservim/nerdtree'
" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
" Start plugin management
" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Set the airline theme
let g:airline_theme='luna'
let g:airline#extensions#tabline#enabled = 1

" Fern
let g:fern#renderer = "nerdfont"
let g:fern#hijack_netrw = 1

let g:fern#disable_default_mappings   = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#disable_viewer_hide_cursor = 1

" Open Fern
nnoremap <silent> <leader>f :Fern . -drawer -toggle -reveal=% -width=35<CR>

" Fern on
function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> C <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernEvents
	  autocmd!
		  autocmd FileType fern call FernInit()
augroup END

" Fern preview
function! s:fern_settings() abort
	  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
	  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
	  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
	  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
 	  nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
endfunction

augroup fern-settings
	  autocmd!
		  autocmd FileType fern call s:fern_settings()
augroup END

" End plugin management

" General settings
set mouse=a
set ignorecase
set smartcase
set number relativenumber

" Colors management
syntax on
colorscheme codedark
set termguicolors
" Can't work with codedark - Override the CursorLine and CursorColumn highlight settings 
" after the codedark colorscheme is loaded
highlight CursorLine ctermbg=LightGrey cterm=bold guibg=#505050
highlight CursorColumn ctermbg=LightGrey cterm=bold guibg=#505050
set cursorline
set cursorcolumn

" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz

" Tab Settings
" set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set timeoutlen=300

" Autocompletion
set wildmode=longest,list,full

" Shortcutting split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Shortcut split opening
nnoremap <leader>h :split<Space><CR>
nnoremap <leader>v :vsplit<Space><CR>

" Alias write and quit to Q
nnoremap <leader>q :wq<CR>
nnoremap <leader>w :w<CR>

" Fix splitting
set splitbelow splitright

" Enable clipboard support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
	augroup END
endif	
