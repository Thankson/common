set nocompatible              " be iMproved  
filetype off                  " required!  
  
set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  
  
" let Vundle manage Vundle  
" " required!   
Bundle 'gmarik/vundle'  

Bundle 'scrooloose/nerdtree'

nnoremap <silent> <F3> :NERDTree<CR>

let Tlist_Auto_Highlight_Tag=1 
let Tlist_Auto_Open=1 
let Tlist_Auto_Update=1 
let Tlist_Display_Tag_Scope=1 
let Tlist_Exit_OnlyWindow=1 
let Tlist_Enable_Dold_Column=1 
let Tlist_File_Fold_Auto_Close=1 
let Tlist_Show_One_File=1 
let Tlist_Use_Right_Window=1 
let Tlist_Use_SingleClick=1 
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
nnoremap <silent> <F8> :TlistToggle<CR>

filetype plugin on 
autocmd FileType python set omnifunc=pythoncomplete#Complete 
autocmd FileType javascrīpt set omnifunc=javascriptcomplete#CompleteJS 
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
autocmd FileType css set omnifunc=csscomplete#CompleteCSS 
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags 
autocmd FileType php set omnifunc=phpcomplete#CompletePHP 
autocmd FileType c set omnifunc=ccomplete#Complete

let g:pydiction_location='~/.vim/tools/pydiction/complete-dict'
set autoindent    " 实现自动缩进
set tabstop=4
set shiftwidth=4    " 
set expandtab    " 把tab转换为空格 
set number

