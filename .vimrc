"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"プラグイン管理
"brew install ctags
"brew install ag

"mkdir -p ~/.vim/bundle
"mkdir -p ~/.vim/plugin
"mkdir -p ~/.vim/colors
"cd ~/.vim/bundle
"git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
"git clone https://github.com/Shougo/vimproc.vim ~/.vim/bundle/vimproc.vim

"vi
":NeoBundleInstall
"ln -s ~/.vim/bundle/molokai/colors/molokai.vim ~/.vim/colors/molokai.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle'))
endif

"インストールしたいプラグインのリスト
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'szw/vim-tags'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-rails'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ngmy/vim-rubocop'
NeoBundle 'romanvbabenko/rails.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'ctrlpvim/ctrlp.vim'

call neobundle#end()

filetype plugin on

filetype indent on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"基本設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"スワップファイルを作成しない
set noswapfile

"行番号表示
set number

"フォントサイズ設定
set guifont=Ricty_Diminished_Discord:h14
set linespace=1

"文字コード設定
set encoding=utf-8

"タブを半角スペースに変換
set expandtab

"ファイルを表示時のタブ幅
set tabstop=2

"キーボードで入力するタブ幅
set softtabstop=2

"自動的に入力されるタブ幅
set shiftwidth=2

"前回の表示位置に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"クリップボードを使用
set clipboard=unnamed

"内容が変更されたら自動的に再読み込み
set autoread

"マウスを有効化
"set mouse=a

"カーソル移動で行間移動を許可
set whichwrap=b,s,<,>,[,]

"行表示を許可
"set cursorline

"カレント行にアンダーラインを設定
"highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

"1行100字制限
set colorcolumn=101

"検索結果をハイライト
set hlsearch

"行末の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

"コマンドライン補完をshellと同一にする
set wildmode=list:longest

"ステータス行を表示
set laststatus=2

"ステータス行にファイルパス名を表示
set statusline=%F

"インクリメンタルサーチに変更
set incsearch

"タブ、空白、改行の可視化
set list
set listchars=tab:>\ ,trail:_

"未保存でも他のファイルを表示できる
set hidden

"backspaceを使う
set backspace=indent,eol,start

"括弧の補完をしない
let loaded_matchparen = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"カラーテーマ設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"背景色(molokai)
syntax enable
set t_Co=256
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

"背景色(solarized)
"syntax enable
"set t_Co=16
"set background=dark
"colorscheme solarized
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"キーボード設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"カーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap <C-e> :NERDTreeToggle<CR>
inoremap <C-e> <ESC>:NERDTreeToggle<CR>

nnoremap <C-t> :tabnew <C-R>=expand("%:p")<CR><CR>
inoremap <C-t> <ESC>:tabnew <C-R>=expand("%:p")<CR><CR>

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap <C-]> g<C-]>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-w> :w<CR>
nnoremap <C-z> :q!<CR>
inoremap <C-]> <ESC>g<C-]>
inoremap <C-n> <C-x><C-n>
inoremap <C-p> <C-x><C-p>
inoremap <C-w> <ESC>:w<CR>
inoremap <C-z> <ESC>:q!<CR>

inoremap <C-f> <C-x><C-f>

nnoremap <C-_> :sp <C-R>=expand("%:p")<CR><CR>
nnoremap <C-\> :vs <C-R>=expand("%:p")<CR><CR>
inoremap <C-_> <ESC>:sp <C-R>=expand("%:p")<CR><CR>
inoremap <C-\> <ESC>:vs <C-R>=expand("%:p")<CR><CR>

nnoremap / /\v

inoremap <Nul> <C-p>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ctags設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"NERDTreeToggle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"ウィンドウ幅を指定
let g:NERDTreeWinSize = 40
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-quickhl
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-rubocop
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-x> :RuboCop<CR>
let g:vimrubocop_config = ".rubocop.yml"
"let g:vimrubocop_rubocop_cmd = "rubocop "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('mac')
  let g:vim_tags_project_tags_command ="/usr/local/bin/ctags -f tags -R . 2>/dev/null"
else
  let g:vim_tags_project_tags_command ="/usr/bin/ctags -f tags -R . 2>/dev/null"
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"taglist
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"タグリストをウィンドウ右側に表示
let Tlist_Use_Right_Window = 1
"表示中のファイルのみタグリストを表示
let Tlist_Show_One_File = 1
"最後のウィンドウの場合はvimを閉じる
let Tlist_Exit_OnlyWindow = 1
"ウィンドウ幅を指定
let Tlist_WinWidth = 40
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-rails
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rails_projections = {
      \ "spec/factories/*.rb": {
      \   "command":   "factory",
      \   "affinity":  "collection",
      \   "alternate": "app/models/%i.rb",
      \   "related":   "db/schema.rb#%s",
      \   "test":      "spec/models/%i_spec.rb",
      \   "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
      \   "keywords":  "factory sequence"
      \ },
      \ "spec/features/*_spec.rb": {
      \   "command":   "feature",
      \   "affinity":  "collection",
      \   "template":  "RSpec.feature \"\" do\n  scenario \"\" do\n  end\nend",
      \   "keywords":  "feature sequence"
      \ }
      \}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-indent-guides
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=23
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=28
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
