" ---------------------------------------------------------------
" Encoding
" ---------------------------------------------------------------
" Must come first so the rest of the file is read as UTF-8
set encoding=utf-8
scriptencoding utf-8

" ---------------------------------------------------------------
" Vim defaults
" ---------------------------------------------------------------
" Load Vim's built-in defaults (syntax on, filetype plugin indent on,
" incsearch, wildmenu, scrolloff=5, ttimeout, last cursor position, ...).
" Vim skips these automatically when ~/.vimrc exists, so load them
" explicitly. Keep this above your own settings so yours override them.
source $VIMRUNTIME/defaults.vim

" ---------------------------------------------------------------
" Appearance
" ---------------------------------------------------------------
" Use 24-bit colors in the terminal
set termguicolors
colorscheme catppuccin_mocha

" Absolute number on the current line, relative numbers elsewhere
set number relativenumber

" ---------------------------------------------------------------
" Whitespace visibility
" ---------------------------------------------------------------
" Uses :let with a double-quoted string so the \u escapes are evaluated
" (:set would take them literally).
"   tab      -> arrow followed by a space as fill
"   space    -> middle dot
"   trail    -> middle dot for trailing whitespace
"   extends  -> shown when a line continues past the right edge
"   precedes -> shown when a line continues past the left edge
"   nbsp     -> open box for non-breaking spaces
let &listchars = "tab:\u2192 ,space:\u00b7,trail:\u00b7,extends:\u203a,precedes:\u2039,nbsp:\u2423"

" Turn the whitespace markers on
set list

" Dim the whitespace markers so they don't distract from the text
" (Catppuccin Mocha surface2).
" SpecialKey covers tab/space/trail/nbsp, NonText covers extends/precedes,
" and Whitespace is the equivalent group in Neovim.
highlight Whitespace ctermfg=8 guifg=#585b70
highlight SpecialKey ctermfg=8 guifg=#585b70
highlight NonText ctermfg=8 guifg=#585b70

" ---------------------------------------------------------------
" clipboard
" ---------------------------------------------------------------

" Use the system clipboard as default
set clipboard=unnamedplus

" ---------------------------------------------------------------
" Searching
" ---------------------------------------------------------------

" Case-insensitive search by default ("foo" matches foo, Foo, FOO)...
set ignorecase
" ...unless the pattern contains an uppercase letter, in which case it
" becomes case-sensitive ("Foo" matches only Foo).
" Note: smartcase only takes effect when ignorecase is also set.
" Tip: add \c or \C anywhere in a pattern to force insensitive/sensitive.
set smartcase

" Highlight all matches of the last search pattern.
set hlsearch

" Press Esc twice in normal mode to clear the current highlighting.
" This only hides the highlights; the search pattern is kept, so
" n / N still jump to the next/previous match.
" <silent> stops Vim from echoing :nohlsearch in the command line.
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" ---------------------------------------------------------------
" Timing
" ---------------------------------------------------------------
" Time to wait for the second key of a mapping such as <Esc><Esc>.
" (defaults.vim already sets ttimeout/ttimeoutlen for terminal key codes.)
set timeoutlen=500

" ---------------------------------------------------------------
" Editing behavior
" ---------------------------------------------------------------
" Persistent undo: you can still undo after closing and reopening a file.
" The directory is created automatically if it doesn't exist.
set undofile
set undodir=~/.vim/undo
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), 'p', 0700)
endif

" Keep 8 lines of context above/below the cursor (defaults.vim uses 5).
set scrolloff=8

" Switch buffers without having to save first.
set hidden

" Open new splits to the right / below, instead of left / above.
set splitbelow splitright

" Complete to the longest common match first, then cycle through the rest.
" (wildmenu itself is already enabled by defaults.vim.)
set wildmode=longest:full,full

" ---------------------------------------------------------------
" Mappings
" ---------------------------------------------------------------
" <leader> is the prefix for custom mappings (default \). Must be set
" before any <leader> mapping. Delete this line to keep the default.
let mapleader = " "

" Keep the selection after indenting with < or > in visual mode,
" so you can press them repeatedly.
vnoremap < <gv
vnoremap > >gv

" Forgot sudo? :w!! saves the file as root.
cnoremap w!! w !sudo tee % >/dev/null

" ---------------------------------------------------------------
" fzf (fzf.vim)
" ---------------------------------------------------------------
" Needs: fzf, fzf + fzf.vim in ~/.vim/pack/plugins/start/, ripgrep (:Rg)
"
" Mappings (<leader> = Space):
"   Ctrl-p / Space f   files in the working directory
"   Space gf           git-tracked files only
"   Space b            open buffers
"   Space h            recent files
"   Space /            lines in the current buffer
"   Space l            lines in all open buffers
"   Space *            grep the word under the cursor
"   Space rg           live ripgrep (updates as you type)
"   Space c            commands
"   Space m            marks
"
" Inside any fzf window:
"   Enter / Ctrl-x / Ctrl-v / Ctrl-t   open here / split / vsplit / tab
"   Tab                                select multiple entries
"   Ctrl-j / Ctrl-k                    move down / up
"   Esc                                close

" Files (Ctrl-p replaces "move up a line", which k already does)
nnoremap <C-p>      :Files<CR>
nnoremap <leader>f  :Files<CR>
nnoremap <leader>gf :GFiles<CR>

" Buffers and history
nnoremap <leader>b  :Buffers<CR>
nnoremap <leader>h  :History<CR>

" Search text
nnoremap <leader>/  :BLines<CR>
nnoremap <leader>l  :Lines<CR>
nnoremap <leader>*  :Rg <C-r><C-w><CR>

" Live ripgrep: rg re-runs on every keystroke (from the fzf.vim README).
" :RG [pattern] runs it, :RG! runs it fullscreen.
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
nnoremap <leader>rg :RG<CR>

" Misc
nnoremap <leader>c  :Commands<CR>
nnoremap <leader>m  :Marks<CR>

" ---------------------------------------------------------------
" LazyGit popup
" ---------------------------------------------------------------
" <leader>g opens lazygit in a centered popup with rounded borders.
" The popup scales with the Vim window and is removed (together with its
" terminal buffer) when lazygit exits.
" Needs: lazygit in $PATH, Vim built with +terminal and +popupwin.

" Popup size as a fraction of the Vim window.
let s:width_ratio = 0.9
let s:height_ratio = 0.85

" Smallest popup (inside the border) in which lazygit stays usable.
let s:min_width = 80
let s:min_height = 24

let s:popup = 0
let s:buf = 0

" Returns [width, height] of the popup contents: scaled to the window,
" raised to the minimum, then capped to what fits on screen (borders and
" command line excluded). The cap wins on very small terminals.
function! s:Size() abort
  let l:width = float2nr(&columns * s:width_ratio)
  let l:height = float2nr(&lines * s:height_ratio)
  let l:width = min([max([l:width, s:min_width]), &columns - 4])
  let l:height = min([max([l:height, s:min_height]), &lines - 6])
  return [l:width, l:height]
endfunction

" Called when lazygit exits: close the popup and wipe the terminal buffer.
function! s:OnExit(job, status) abort
  if s:popup
    call popup_close(s:popup)
    let s:popup = 0
  endif
  if bufexists(s:buf)
    execute 'bwipeout!' s:buf
  endif
  checktime
endfunction

" Keep the popup in step with the window when Vim is resized.
function! s:OnResize() abort
  if !s:popup || empty(popup_getpos(s:popup))
    return
  endif
  let [l:width, l:height] = s:Size()
  call popup_setoptions(s:popup, {
        \ 'minwidth': l:width, 'maxwidth': l:width,
        \ 'minheight': l:height, 'maxheight': l:height,
        \ })
endfunction

function! s:LazyGit() abort
  if !executable('lazygit')
    echoerr 'lazygit is not installed or not in $PATH'
    return
  endif
  if !has('terminal') || !has('popupwin')
    echoerr 'LazyGit requires Vim with +terminal and +popupwin'
    return
  endif

  let s:buf = term_start('lazygit', {'hidden': 1, 'exit_cb': function('s:OnExit')})
  let [l:width, l:height] = s:Size()

  " borderchars order: top, right, bottom, left,
  "                    top-left, top-right, bottom-right, bottom-left
  let s:popup = popup_create(s:buf, {
        \ 'pos': 'center',
        \ 'minwidth': l:width,
        \ 'maxwidth': l:width,
        \ 'minheight': l:height,
        \ 'maxheight': l:height,
        \ 'border': [1],
        \ 'borderchars': ["\u2500", "\u2502", "\u2500", "\u2502",
        \                 "\u256d", "\u256e", "\u256f", "\u2570"],
        \ })
endfunction

augroup my_lazygit
  autocmd!
  autocmd VimResized * call s:OnResize()
augroup END

nnoremap <silent> <leader>gg :call <SID>LazyGit()<CR>

" ---------------------------------------------------------------
" Files and buffers
" ---------------------------------------------------------------
" Reload files that changed on disk (e.g. after lazygit checkouts or pulls).
" checktime runs when you re-enter a buffer or the terminal regains focus.
" (FocusGained needs a terminal that sends focus events; BufEnter works everywhere.)
set autoread
augroup my_autoread
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold * if mode() != 'c' | checktime | endif
augroup END

" No backup files, and keep swap files out of your project directories
" (so git status stays clean). The trailing // makes names unique per path.
set nobackup nowritebackup
set directory=~/.vim/swap//
if !isdirectory(expand('~/.vim/swap'))
  call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif

" Faster CursorHold events (default is 4000 ms); used by plugins and autoread.
set updatetime=300

" ---------------------------------------------------------------
" Indentation and formatting
" ---------------------------------------------------------------
" Default indentation: 4 spaces. Your C/dts autocmd overrides this with tabs.
set expandtab shiftwidth=4 softtabstop=4

" Pressing o/O on a comment line should not start a new comment line.
" Done in an autocmd because filetype plugins would otherwise reset it.
augroup my_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions-=o
augroup END

" Spell checking only where prose is written.
augroup my_spell
  autocmd!
  autocmd FileType gitcommit,markdown,text setlocal spell spelllang=en
augroup END

" ---------------------------------------------------------------
" Terminal
" ---------------------------------------------------------------
" Cursor shape: beam in insert mode, block in normal, underline in replace.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" ---------------------------------------------------------------
" More mappings
" ---------------------------------------------------------------
" Y yanks to end of line, consistent with D and C (default is the same as yy).
nnoremap Y y$

" Move between windows with Ctrl-h/j/k/l instead of Ctrl-w h/j/k/l.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

