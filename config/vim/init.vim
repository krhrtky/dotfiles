filetype plugin indent on
filetype off

augroup auto_comment_off
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" dein config start
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_lib = s:dein_repo_dir . '/lib'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/dotfiles/config/vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" dein config end
let g:deoplete#enable_at_startup = 1
inoremap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "<CR>"

" FileType毎のOmni補完を設定
autocmd FileType python set omnifunc=jedi#completions
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType htmlcheetah set omnifunc=htmlcomplete#CompleteTags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" neosnipet config start
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" neosnipet config end

" rsenseでの自動補完機能を有効化
let g:rsenseUseOmniFunc = 1
" let g:rsenseHome = '/usr/local/lib/rsense-0.3'

" auto-ctagsを使ってファイル保存時にtagsファイルを更新
let g:auto_ctags = 1

let g:vim_tags_auto_generate = 1

nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
nnoremap <C-k> :split<CR> :exe("tjump ".expand('<cword>'))<CR><Paste>

" Plugin config start
let g:vimproc_dll_path = '/Users/takuya.kurihara/.cache/dein/repos/github.com/Shougo/vimproc.vim/lib/vimproc_mac.so'
"let g:vimproc_dll_path = '/Users/takuya.kurihara/.cache/dein/repos/github.com/Shougo/vimproc.vim/lib/'
let g:ref_jquery_doc_path = s:dein_repo_dir . '/mustardamus/jqapi'
let g:ref_javascript_doc_path = s:dein_repo_dir. '/tokuhirom/jsref/htdocs'

set t_Co=256 " この設定がないと色が正しく表示されない

" NERDTreeToggle shortcut
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" GO config start
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
"autocmd FileType go autocmd BufWritePre <buffer> Fmt
"let g:neocomplete#sources#omni#input_patterns.go = '\h\w\.\w*'
let g:go_bin_path = $GOPATH.'/bin'
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
"autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow

" TS config
"let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.u
"autocmd BufRead,BufNewFile *.ts set filetype=typescript
"autocmd BufNewFile,BufRead *.tsx set filetype=typescript

au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app"'

let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'go': ['gometalinter'],
\   'ruby': ['rubocop'],
\}

let g:ale_fixers = {
      \ 'javascript': ['prettier', 'eslint'],
      \ 'typescript': ['prettier'],
      \ }
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1

let g:ale_sign_column_always = 1

let g:ale_typescript_tslint_config_path = ''
"let g:ale_typescript_tslint_executable = 'tslint --project tsconfig.json'
let g:ale_typescript_tslint_ignore_empty_files = 0
let g:ale_typescript_tslint_options = '--no-ignore'
let g:ale_typescript_tslint_rules_dir = ''
let g:ale_typescript_tslint_use_global = 0

let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     [ 'mode', 'paste' ],
        \     [ 'fugitive', 'filename' ],
        \     [ 'readonly', 'filename', 'modified', 'ale' ]
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightlineModified',
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \   'filetype': 'MyFiletype',
        \   'fileformat': 'MyFileformat',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode',
        \   'ale': 'ALEGetStatusLine'
        \ }
        \ }

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

autocmd  FileType nerdtree setlocal  nolist
let g:WebDevIconsNerdTreeAfterGlyphPadding  =  ''

let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }

let g:lightline.tab_component_function = {
      \ 'filename': 'LightlineTabFilename',
      \ 'modified': 'lightline#tab#modified',
      \ 'readonly': 'lightline#tab#readonly',
      \ 'tabnum': 'lightline#tab#tabnum' }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'denite' ?denite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! MyFileformat()
      return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    endfunction ') ')

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction


" 補完の設定
" Rsense用の設定
let g:rsenseUseOmniFunc = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'
let g:rsenseHome = expand("/Users/takuya.kurihara/.rbenv/shims/rsense")
let g:neocomplete#sources#rsense#home_directory = '/Users/takuya.kurihara/.rbenv/shims/rsense'
" With deoplete.nvim
let g:monster#completion#rcodetools#backend = "async_rct_complete"
"let g:deoplete#sources#omni#input_patterns = {
"\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
"\}


" emmet keybind
let g:user_emmet_leader_key = '<C-E>'
let g:user_emmet_settings = {
    \    'variables': {
    \      'lang': "ja"
    \    },
    \   'indentation': '  '
    \ }


" define fileencodings to open as utf-8 encoding even if it's ascii.
function! s:gofiletype_pre() abort
  let s:current_fileformats = &g:fileformats
  let s:current_fileencodings = &g:fileencodings
  set fileencodings=utf-8 fileformats=unix
  setlocal filetype=go
endfunction

" restore fileencodings as others
function! s:gofiletype_post() abort
  let &g:fileformats = s:current_fileformats
  let &g:fileencodings = s:current_fileencodings
endfunction

au BufNewFile *.go setlocal filetype=go fileencoding=utf-8 fileformat=unix
au BufRead *.go call s:gofiletype_pre()
au BufReadPost *.go call s:gofiletype_post()

let g:deoplete#sources#ternjs#tern_bin = '~/.nodebrew/current/bin/'

let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1

" Whether to include the distance (in scopes for variables, in prototypes for
" properties) between the completions and the origin position in the result
" data. Default: 0
let g:deoplete#sources#ternjs#depths = 1

" Whether to include documentation strings (if found) in the result data.
" Default: 0
let g:deoplete#sources#ternjs#docs = 1

" When on, only completions that match the current word at the given point will
" be returned. Turn this off to get all results, so that you can filter on the
" client side. Default: 1
let g:deoplete#sources#ternjs#filter = 0

" Whether to use a case-insensitive compare between the current word and
" potential completions. Default 0
let g:deoplete#sources#ternjs#case_insensitive = 1

" When completing a property and no completions are found, Tern will use some
" heuristics to try and return some properties anyway. Set this to 0 to
" turn that off. Default: 1
let g:deoplete#sources#ternjs#guess = 0

" Determines whether the result set will be sorted. Default: 1
let g:deoplete#sources#ternjs#sort = 0

" When disabled, only the text before the given position is considered part of
" the word. When enabled (the default), the whole variable name that the cursor
" is on will be included. Default: 1
let g:deoplete#sources#ternjs#expand_word_forward = 0

" Whether to ignore the properties of Object.prototype unless they have been
" spelled out by at least two characters. Default: 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0

" Whether to include JavaScript keywords when completing something that is not
" a property. Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1

" If completions should be returned when inside a literal. Default: 1
let g:deoplete#sources#ternjs#in_literal = 0


"Add extra filetypes
let g:deoplete#sources#ternjs#filetypes = [
                \ 'jsx',
                \ 'javascript.jsx',
                \ 'javascript',
                \ 'typescript',
                \ 'vue',
                \ '...'
                \ ]

" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

let g:tigris#enabled = 1
let g:tigris#on_the_fly_enabled = 1
let g:tigris#delay = 300

" NERDTree config
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
autocmd VimEnter * execute 'NERDTree'

nnoremap <silent> <C-p> :<C-u>Denite file_rec<CR>

"nomal config"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文字コード
set encoding=utf-8
" 書込文字コード
set fileencoding=utf-8
" 読込文字コード
set fileencodings=utf-8,euc-jp,shift_jis
"colorscheme molokai
colorscheme solarized
set wildmenu
set wildmode=full
syntax on
" show whitespace
set number
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set backspace=indent,eol,start
hi Comment ctermfg=DarkGray
" indent
set expandtab " tab replace whitespace
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set shiftwidth=2
set cursorline
set directory=/tmp
"set shell=/bin/sh
set sh=zsh
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
" 補完ウィンドウの設定
set completeopt=menuone
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_folding_disabled=1
autocmd BufWritePre * :%s/\s\+$//ge
autocmd FileType * setlocal formatoptions-=r
autocmd FileType * setlocal formatoptions-=o
nnoremap <Esc><Esc> :noh<CR>

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

augroup HighligntTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END
let g:go_fmt_command = "gofmt"

"if executable('gjs')
"  let g:quickrun_config.javascript = {
"        \ 'command'   : 'gjs',
"        \ 'exec'      : '%c %s',
"        \ }
"endif

map <C-]> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" 新しいタブでターミナルを起動
nnoremap @t :vs<CR>:terminal<CR>
" Ctrl + q でターミナルを終了
tnoremap <C-q> <C-\><C-n>:q<CR>
" ESCでターミナルモードからノーマルモードへ
tnoremap <ESC> <C-\><C-n>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
