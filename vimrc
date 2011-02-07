call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Sets how many lines of history VIM has to remember
set history=300

set shm=atI " Disable intro screen

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set wildmenu "Turn on WiLd menu

set ruler "Always show current position

set cmdheight=1 "The commandbar height

set hid "Change buffer - without saving

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell

set hidden
set number
set ts=2 sts=2 sw=2 expandtab
syntax on


set tf " Improves redrawing for newer computers

if has("autocmd")
	filetype plugin indent on
endif 


" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


" Fast saving
nmap <leader>w :w!<cr>


" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
nnoremap <leader>ev <C-w><C-v><C-l>:e ~/.vimrc<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
nnoremap <leader>w <C-w>v<C-w>l


" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
"map <right> :bn<cr>
"map <up> :bn<cr>
"map <left> :bp<cr>
"map <down> :bp<cr>

" Don't use the arrow keys for something useful
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
nnoremap j gj
nnoremap k gk


" Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>te :tabedit 
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

set lbr
set tw=500

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines

map <leader>t2 :setlocal shiftwidth=2<cr>
map <leader>t4 :setlocal shiftwidth=4<cr>
map <leader>t8 :setlocal shiftwidth=8<cr>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction



""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

function! CurDir()
   let curdir = substitute(getcwd(), '/home/avanherk/', "~/", "g")
   return curdir
endfunction


" Function used to display syntax group. 
function! SyntaxItem() 
  return synIDattr(synID(line("."),col("."),1),"name") 
endfunction 

" Function used to display utf-8 sequence. 
function! ShowUtf8Sequence() 
  let p = getpos('.') 
  redir => utfseq 
  sil normal! g8 
  redir End 
  call setpos('.', p) 
  return substitute(matchstr(utfseq, '\x\+ .*\x'), '\<\x', '0x&', 'g') 
endfunction 

if has('statusline') 
  if version >= 700 
    " Fancy status line. 
    set statusline = 
    "set statusline+=%#User1#                       " highlighting 
    set statusline+=%-2.2n\                        " buffer number 
    "set statusline+=%#User2#                       " highlighting 
    set statusline+=%f\                            " file name 
    "set statusline+=%#User1#                       " highlighting 
    set statusline+=%h%m%r%w\                      " flags 
    set statusline+=CWD:\%r%{CurDir()}%h,
    set statusline+=%{(&key==\"\"?\"\":\"encr,\")} " encrypted? 
    set statusline+=%{strlen(&ft)?&ft:'none'},     " file type 
    set statusline+=%{(&fenc==\"\"?&enc:&fenc)},   " encoding 
    set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM 
    set statusline+=%{&fileformat},                " file format 
    set statusline+=%{&spelllang},                 " spell language 
    set statusline+=%{SyntaxItem()}                " syntax group under cursor 
    set statusline+=%=                             " indent right 
    "set statusline+=%#User2#                       " highlighting 
    set statusline+=%{ShowUtf8Sequence()}\         " utf-8 sequence 
    "set statusline+=%#User1#                       " highlighting 
    set statusline+=0x%B\                          " char under cursor 
    set statusline+=%-6.(%l,%c%V%)\ %<%P           " position 

    " Use different colors for statusline in current and non-current window. 
    let g:Active_statusline=&g:statusline 
    let g:NCstatusline=substitute( 
      \                substitute(g:Active_statusline, 
      \                'User1', 'User3', 'g'), 
      \                'User2', 'User4', 'g') 
    au WinEnter * let&l:statusline = g:Active_statusline 
    au WinLeave * let&l:statusline = g:NCstatusline 
  endif 
endif 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab teh the
iab htis this
iab tihs this
iab eariler earlier
iab funciton function
iab funtion function
iab fucntion function
iab retunr return
iab reutrn return
iab foreahc foreach
iab !+ !=
iab eariler earlier
iab !+ !=
iab ~? ~/

iab todo: TODO:
iab done: DONE:
iab fixme: FIXME:
iab fixed: FIXED:

iab avh Aaron van Herk <aaron.vanherk@gmail.com>
" lorem ipsum
inoreabbrev dolorem Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
inoreabbrev mdash &nbsp;&mdash;
inoreabbrev nbsp &nbsp;
inoreabbrev <<< &lt;
inoreabbrev >>> &gt



""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1


""""""""""""""""""""""""""""""
" => Minibuffer plugin
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = -1
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplVSplit = 25
"let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

"autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>:TMiniBufExplorer<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,s will toggle and untoggle spell checking
map <leader>s :setlocal spell!<cr>

"spell language
set spelllang=en_au
set spellsuggest=5

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


""""""""""""""""""""""""""""""""""""""
" => Fast opening of files
""""""""""""""""""""""""""""""""""""""
"Open the .vimrc
map <leader>e :e! ~/.vimrc<cr>

"Open hosts file"
map <leader>h :e! /etc/hosts<cr>

"Open zshrc"
map <leader>z :e! ~/.zshrc<cr>

"Open local zshrc"
map <leader>zl :e! ~/.zshrc.local<cr>

"Open env zsh
map <leader>ze :e! ~/.zshenv<cr>


"Open bashrc"
map <leader>b :e! ~/.bashrc<cr>

"Open local bashrc"
map <leader>bl :e! ~/.bashrc.local<cr>

"Open env bashrc
map <leader>be :e! ~/.bashrc.env<cr>

"Open env bashrc
map <leader>ba :e! ~/.bashrc.aliases<cr>

""""""""""""""""""""""""""""""""""""""
" => NERDTREE Helpers
""""""""""""""""""""""""""""""""""""""
nmap <F12> :NERDTreeToggle<cr>
nmap <leader>ob :OpenBookmark

""""""""""""""""""""""""""""""""""""""
" =>   Show hidden Chars
""""""""""""""""""""""""""""""""""""'"
nmap <leader>l :set list!<CR>

"change the tab and end of line chars
set listchars=tab:▸\ ,eol:¬


" In insert mode use jj to get to normal mode
inoremap jj <ESC>

"Ack
nnoremap <leader>a :Ack

set vb t_vb=
set t_vb=
