set nocompatible
filetype on
syntax on
set number
set cursorline
set shiftwidth=4
set tabstop=4
set expandtab
set history=1000
set nobackup
set updatetime=300
set noerrorbells
set visualbell
set t_vb=
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
let mapleader = "\<Space>"

call plug#begin()

Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'jiangmiao/auto-pairs'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-commentary'

call plug#end()

colorscheme moonfly

let NERDTreeShowHidden=1
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTreeFocus<CR>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> <C-d> <Plug>(coc-scroll-down)
nnoremap <silent> <C-u> <Plug>(coc-scroll-up)
inoremap <silent><expr> <C-Space> coc#refresh()
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
