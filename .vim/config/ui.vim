" UI and appearance
syntax on
set termguicolors
colorscheme codedark

" Can't work with codedark - Override the CursorLine and CursorColumn highlight settings 
" after the codedark colorscheme is loaded
" highlight CursorLine ctermbg=LightGrey cterm=bold guibg=#505050
" highlight CursorColumn ctermbg=LightGrey cterm=bold guibg=#505050
" set cursorline
" set cursorcolumn

# " Vertically center document when entering insert mode
# autocmd InsertEnter * norm zz


" Cursor settings
set cursorline
set cursorcolumn
highlight CursorLine ctermbg=LightGrey cterm=bold guibg=#505050
highlight CursorColumn ctermbg=LightGrey cterm=bold guibg=#505050

" Center document on insert
autocmd InsertEnter * norm zz
