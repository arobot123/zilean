" ============================================================================================ "
"                                          VIM 基础配置
" ============================================================================================ "
" 设置编码方式
set encoding=utf-8
" 自动判断编码时，依次尝试编码
set fileencodings=utf-8,gbk
" 设置文件格式unix
set ff=unix
" 不与vi兼容，使用vim自己的命令
set nocompatible
" 支持鼠标
set mouse=a



" 语法高亮
syntax enable
syntax on
" 启用256色
set t_Co=256

" 显示行号
set number
" 显示光标所在当前行号，其他行相对于该行的行号
set relativenumber

" 突出显示当前行
set cursorline
" 突出显示当前列
"set cursorcolumn
" 显示括号匹配
set showmatch
" 高亮显示搜索结果
set hlsearch


" 显示不可见字符，并定制行尾空格、tab键显示符号
set list
set listchars=tab:>-,trail:-,precedes:«,extends:»
" 设置行宽
"set textwidth=80
" 设置自动换行（单行字符超过行宽）
set wrap
" 设置遇到指定字符换行
set linebreak
" 指定折行处与编辑窗口右边缘之间空处的字符数
set wrapmargin=2

" 水平滚动时光标距离行首/尾字符数(不折行时使用)
set scrolloff=3
" 垂直滚动时光标距离顶/底部行数
"set sidescrolloff=5

" 显示状态栏
set laststatus=2
" 状态栏显示正在输入的命令
set showcmd
" 状态栏显示光标行列位置
set ruler
" 底部显示当前模式
set showmode


" 英语单词拼写检查
set spell spelllang=en_us,cjk
nmap <F5> :set spell!<CR>



" 开启文件类型检查，并载入该类型对应的缩进规则(如.py文件加载，$HOME/.vim/intent/python.vim)
" 这里使用统一缩进
filetype on
filetype indent on
" 允许插件
filetype plugin on
" 启动智能补全(ctrl-p)
filetype plugin indent on

" 回车自动同上行缩进
set autoindent
" Tab缩进空格数
set tabstop=4
" 文本上增加/取消一级或者取消全部缩进时，每级字符数
set shiftwidth=4
" Tab转空格
set expandtab
" Tab转空格数
set softtabstop=4
" 按退格键一次删除4个空格
set smarttab



" 搜索模式时，每输入一个字符自动跳到第1个匹配结果
set incsearch
" 搜索时忽略大小写
set ignorecase
" 配合ignorecase，只对第1个字母大小写敏感。搜Test不匹配test，但搜test匹配Test
set smartcase


" 设置历史记录条数
set history=10
" 取消备份
set nobackup
" 禁止临时文件生成
set noswapfile


" 自动切换到当前文件目录
set autochdir
" 出错时发出响声
set errorbells
" 出错时发出视觉提示
set visualbell
" 编辑时文件发生外部变更，给出提示
set autoread
" 命令模式下，底部操作指令按Tab补全，第1次按显示所有匹配指令清单，第2次按以次选择各指令
set wildmenu
set wildmode=longest:list,full



" 多文件打开Tab切换
nmap <TAB> :bn<CR>
