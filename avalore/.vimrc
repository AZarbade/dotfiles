" options
set cursorline
set scrolloff=10
set signcolumn=yes
set number
set relativenumber
set undofile
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set termguicolors
set diffopt+=iwhite
set diffopt+=algorithm:histogram
set diffopt+=indent-heuristic
let g:netrw_liststyle = 3

colorscheme habamax
hi statusline guibg=NONE
syntax on

" keymaps
let mapleader=" "
nnoremap <leader>e :Ex<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :Buffers<CR>

" special yank
vnoremap <silent> <leader>y :w !wl-copy<CR><CR>

" Move focus between windows
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

let s:plugin_dir = expand('~/.vim/plugged')

function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name

  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif

  execute 'set runtimepath+=' . fnameescape(path)
endfunction

call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')
call s:ensure('yegappan/lsp')

" Prevent accidental writes to buffers that shouldn't be edited
augroup readonly_files
    autocmd!
    autocmd BufRead *.orig set readonly
    autocmd BufRead *.pacnew set readonly
augroup END

" Enable diagnostics highlighting
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)
let lspServers = [
      \ #{name: 'rust-analyzer', filetype: ['rust'], path: 'rust-analyzer', args: []},
      \ #{name: 'ruff', filetype: ['python'], path: 'ruff', args: ['server']},
      \ ]
autocmd User LspSetup call LspAddServer(lspServers)

" Key mappings
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
