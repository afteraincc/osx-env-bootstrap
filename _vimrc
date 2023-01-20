" ============================================
" functions
" ============================================
function! IsWindows()
    if (has("win32") || has("win64"))
        return 1
    else
        return 0
    fi
endfunction

function! IsMac()
    if (has('macunix'))
        return 1
    else
        return 0
    end
endfunction

function! ConfigVundle()
endfunction

function! ConfigVimEdit()
    set nocompatible
    filetype plugin indent on
    set autoindent
    set shiftwidth=4
    set tabstop=4
    set softtabstop=4
    set expandtab
    set smarttab
    autocmd FileType ruby,eruby,yaml,js set shiftwidth=2 | set softtabstop=2 |
                                   \ set tabstop=2 | set expandtab |
                                   \ set smarttab
    set wrap
    set ignorecase smartcase
    set backspace=indent,eol,start
    set clipboard=unnamed
endfunction

function! ConfigVimEncoding()
    set encoding=utf-8
    set fileencodings=utf-8,gb2312,gbk,gb18030
    set termencoding=utf-8
    if (IsWindows())
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        "set langmenu=zh_CN.UTF-8
        language messages zh_CN.utf-8
    endif
endfunction

function! ConfigVimHighlight()
    set cursorline
    set hlsearch
endfunction

function! ConfigVimSearch()
    set incsearch
endfunction

function! SaveSession()
    if (filereadable("session.vim"))
        execute 'mksession! session.vim'
        :wviminfo viminfo
    endif
endfunction

function! LoadSession()
    if (filereadable("session.vim"))
        if (filereadable("viminfo"))
            :rviminfo viminfo
        endif
        silent! execute 'source session.vim'
        redraw!
    endif
endfunction

function! ForceSaveSession()
    execute 'mksession! session.vim'
    redraw!
endfunction

function! ConfigVimSession()
    set sessionoptions=
    set sessionoptions+=sesdir,slash,unix,resize,winpos,buffers,folds,help
    autocmd VimEnter * call LoadSession()
    autocmd VimLeave * call SaveSession()
    map <silent> <leader>ss :call ForceSaveSession()<CR>
endfunction

function! ConfigVimOther()
    syntax on
    set guioptions-=m
    set history=1000
    set ignorecase smartcase
    set mouse=a
    set nobackup
    set number
    set paste
    set wrap
    set cc=81
    "let g:EclimCompletionMethod = 'omnifunc'
endfunction

function! ConfigAirline()
    "let g:airline_theme="base16"
    let g:airline_theme="angr"

    "打开tabline功能,方便查看Buffer和切换
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#tabline#buffer_nr_show = 1
    "设置切换Buffer快捷键
    nnoremap <C-N> :bn<CR>
    nnoremap <C-P> :bp<CR>
    " 关闭状态显示空白符号计数
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#whitespace#symbol = '!'
endfunction

function! ConfigVimBell()
    set noerrorbells
    set novisualbell
    set vb t_vb=
    autocmd GuiEnter * set t_vb=
endfunction

function! ConfigVimPrint()
    if (!IsWindows())
        "set printdevice=iP1880-series "printer, use system printer if not
        set printencoding=utf-8 "encoding of printing. use encoding if not set.
        "charset of print. should be compatible with printencoding.
        set printmbcharset=ISO10646
        "set printmbfont=r:MSungGBK-Light,c:yes
        "打印所用字体, 在linux下,要用ghostscript里已有的字体, 不然会打印乱码.
        set printmbfont=r:STSong-Light,c:yes
        "打印可选项, formfeed: 是否处理换页符, header: 页眉大小,
        " paper:"用何种纸, duplex: 是否双面打印, syntax: 是否支持语法高
        set printoptions=formfeed:y,paper:A4,duplex:on,syntax:y",header:3
        "set printheader=%<%f%h%m%=Page\ %N "打印时页眉的格式
    endif
endfunction

function! ConfigVimListChar()
    " 非可见字符
    set listchars=tab:>-,trail:-,extends:>,precedes:< " display tab
    set list
endfunction

function! ConfigVimFold()
    set foldmethod=indent
    set foldlevel=99
endfunction

function! ConfigVimColorScheme()
    "colorscheme blackboard
    colorscheme gruvbox
    set background=dark
endfunction

function! ConfigVimLeader()
    "let mapleader = ","
    let g:mapleader = ","
endfunction

function! ConfigVimrc()
    if (IsWindows())
        map <silent> <leader>lv :source $VIM/_vimrc<cr>
        map <silent> <leader>ev :e $VIM/_vimrc<cr>
    else
        map <silent> <leader>lv :source $HOME/.vimrc<cr>
        map <silent> <leader>ev :e $HOME/.vimrc<cr>
    endif
endfunction

function! ConfigVimShortcut()
    if has("gui_running")
        map <M-w> :bd<CR>
    else
        map <Esc>w :bd<CR>
    endif
endfunction

function! BeforeVim()
    call ConfigVimLeader()
    if (IsWindows())
        source $VIMRUNTIME/vimrc_example.vim
        source $VIMRUNTIME/mswin.vim
        behave mswin
    endif
endfunction

function! DoVim()
    call ConfigVimBell()
    call ConfigVimColorScheme()
    call ConfigVimEdit()
    call ConfigVimEncoding()
    call ConfigVimFold()
    call ConfigVimHighlight()
    call ConfigVimListChar()
    call ConfigVimOther()
    call ConfigVimrc()
    call ConfigVimSearch()
    call ConfigVimSession()
    call ConfigVimShortcut()
endfunction

function! AfterVim()
endfunction

function! ConfigVim()
    call BeforeVim()
    call DoVim()
    call AfterVim()
endfunction

function! ConfigPluginPython()
    " pep8
    let g:pep8_map='<leader>8'

    " pydoc settings for pydoc.vim to find pydoc command in windows
    if (IsWindows())
        let g:pydoc_cmd = 'C:\Python25\Lib\pydoc.py'
    endif

    " pyflakes
    let g:pyflakes_use_quickfix = 0

    " pysmell
    "autocmd FileType python setlocal omnifunc=pysmell#Complete
endfunction

function! ConfigPluginRuby()
    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1
    map <silent> <leader>rc :Rcontroller 
    map <silent> <leader>rf :Rfind 
    map <silent> <leader>rg :Rgenerate 
    map <silent> <leader>rj :Rjavascript 
    map <silent> <leader>rm :Rmodel 
    map <silent> <leader>rss :Rserver<CR>
    map <silent> <leader>rsr :Rserver!<CR>
    map <silent> <leader>rv :Rview 
endfunction

function! ConfigPluginZenCoding()
    map <silent> <leader>zz :call zencoding#expandAbbr(3, "")<CR>
    map <silent> <leader>zc :call zencoding#toggleComment()<CR>
    map <silent> <leader>zn :call zencoding#moveNextPrev(0)<CR>
    map <silent> <leader>zN :call zencoding#moveNextPrev(1)<CR>
endfunction

function! BeforePlugin()
endfunction

function! DoPlugin()
    call ConfigAirline()
    call ConfigPluginPython()
    call ConfigPluginRuby()
    call ConfigPluginZenCoding()
endfunction

function! AfterPlugin()
endfunction

function! ConfigPlugin()
    call BeforePlugin()
    call DoPlugin()
    call AfterPlugin()
endfunction

" ============================================
" config
" ============================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'morhetz/gruvbox'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()

call ConfigVim()
call ConfigPlugin()
