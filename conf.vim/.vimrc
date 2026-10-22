" ===============================================================
" .vimrc
" ===============================================================
" Sections:
"   1. Encoding              8. Editing
"   2. Vim defaults          9. Searching
"   3. Leader key           10. Files, undo and swap
"   4. Appearance           11. Windows and buffers
"   5. Whitespace markers   12. General mappings
"   6. Terminal and timing  13. fzf
"   7. Indentation          14. LazyGit
"
" Keybindings follow LazyVim where Vim allows it. <leader> is Space.

" ---------------------------------------------------------------
" 1. Encoding
" ---------------------------------------------------------------
" Must come first so the rest of the file is read as UTF-8.
set encoding=utf-8
scriptencoding utf-8

" ---------------------------------------------------------------
" 2. Vim defaults
" ---------------------------------------------------------------
" Vim skips its built-in defaults (syntax on, filetype plugin indent on,
" incsearch, wildmenu, scrolloff=5, ttimeout, last cursor position, ...)
" as soon as a ~/.vimrc exists, so load them explicitly. Keep this above
" your own settings so that yours override them.
source $VIMRUNTIME/defaults.vim

" ---------------------------------------------------------------
" 3. Leader key
" ---------------------------------------------------------------
" Prefix for custom mappings (default \). Must be set before any
" <leader> mapping in this file.
let mapleader = " "

" ---------------------------------------------------------------
" 4. Appearance
" ---------------------------------------------------------------
" 24-bit colors in the terminal (the Catppuccin theme only defines
" GUI colors, so it needs this).
set termguicolors
colorscheme catppuccin_mocha

" Always show the statusline (Vim has no global statusline like Neovim).
set laststatus=2

" Absolute number on the current line, relative numbers elsewhere.
set number relativenumber

" Highlight the line the cursor is on.
set cursorline

" Wrap long lines at word boundaries instead of mid-word.
set linebreak

" Lines of context kept around the cursor when scrolling
" (defaults.vim uses scrolloff=5).
set scrolloff=8
set sidescrolloff=8

" ---------------------------------------------------------------
" 5. Whitespace markers
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
set list

" Dim the markers so they don't distract from the text
" (Catppuccin Mocha surface2). These must come AFTER :colorscheme,
" because the theme starts with `hi clear`.
"   SpecialKey: tab/space/trail/nbsp    NonText: extends/precedes
"   Whitespace: the equivalent group in Neovim
highlight Whitespace ctermfg=8 guifg=#585b70
highlight SpecialKey ctermfg=8 guifg=#585b70
highlight NonText ctermfg=8 guifg=#585b70

" ---------------------------------------------------------------
" 6. Terminal and timing
" ---------------------------------------------------------------
" How long Vim waits for the next key of a mapping such as <Space>sg.
set timeoutlen=500

" How long Vim waits after Esc to see whether it starts a key code.
" (Esc followed by j or k within this time counts as Alt-j / Alt-k.)
set ttimeoutlen=50

" Idle time in ms before CursorHold fires and the swap file is written
" (default 4000). Makes the autoread check below respond quickly.
set updatetime=300

" Terminals send Alt+key as <Esc>key; tell Vim to read that as <M-key>.
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"

" Cursor shape per mode: beam in insert, block in normal, underline in
" replace. Remove these three lines if your terminal ignores them.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"

" ---------------------------------------------------------------
" 7. Indentation and formatting
" ---------------------------------------------------------------
" Default: 4 spaces per indent level, Tab inserts spaces.
set expandtab shiftwidth=4 softtabstop=4

" Round indents made with < and > to a multiple of shiftwidth.
set shiftround

" Copy the indent of the previous line and indent after braces.
set smartindent

" Pressing o/O on a comment line does not start a new comment line.
" Done in an autocmd because filetype plugins would reset a plain :set.
" (LazyVim keeps the default; delete this block to match it.)
augroup my_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions-=o
augroup END

" ---------------------------------------------------------------
" 8. Editing
" ---------------------------------------------------------------
" Use the system clipboard for all yanks and pastes.
set clipboard=unnamedplus

" Let the cursor move past the end of a line in visual block mode.
set virtualedit=block

" Insert-mode completion popup: at most 10 entries, always show the menu,
" and don't preselect an entry.
set pumheight=10
set completeopt=menu,menuone,noselect

" Command-line completion: first Tab completes the longest common text
" and shows the menu, further Tabs cycle through the matches.
" (wildmenu itself is enabled by defaults.vim.)
set wildmode=longest:full,full

" Start with all folds open.
set foldlevel=99

" Spell checking only where prose is written.
" ]s / [s jump between errors, z= suggests, zg adds a word.
augroup my_spell
  autocmd!
  autocmd FileType gitcommit,markdown,text setlocal spell spelllang=en
augroup END

" ---------------------------------------------------------------
" 9. Searching
" ---------------------------------------------------------------
" Case-insensitive by default ("foo" matches foo, Foo, FOO)...
set ignorecase
" ...unless the pattern contains an uppercase letter, then it is
" case-sensitive. Only works together with ignorecase.
" Add \c or \C to a pattern to force insensitive / sensitive.
set smartcase

" Highlight all matches of the last search.
set hlsearch

" Esc Esc clears the highlighting. The pattern is kept, so n / N still work.
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" n always searches forward and N backward, and both open folds.
nnoremap <expr> n 'Nn'[v:searchforward] . 'zv'
nnoremap <expr> N 'nN'[v:searchforward] . 'zv'

" Use ripgrep for :grep, with column numbers in the quickfix list.
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m

" ---------------------------------------------------------------
" 10. Files, undo and swap
" ---------------------------------------------------------------
" Ask instead of failing on :q with unsaved changes, and save
" automatically before commands such as :next and :make.
set confirm
set autowrite

" Switch buffers without having to save first.
set hidden

" Reload files that changed on disk (after lazygit checkouts, pulls, ...).
" checktime runs when entering a buffer, regaining focus, or when idle.
" (FocusGained needs a terminal that sends focus events.)
set autoread
augroup my_autoread
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold * if mode() != 'c' | checktime | endif
augroup END

" No backup files. Swap files go to ~/.vim/swap so git status stays clean;
" the trailing // makes the names unique per full path.
set nobackup nowritebackup
set directory=~/.vim/swap//
if !isdirectory(expand('~/.vim/swap'))
  call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif

" Persistent undo: undo still works after closing and reopening a file.
set undofile
set undodir=~/.vim/undo
set undolevels=10000
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), 'p', 0700)
endif

" ---------------------------------------------------------------
" 11. Windows and buffers
" ---------------------------------------------------------------
" New splits open to the right / below instead of left / above.
set splitbelow splitright

" Move between windows with Ctrl-h/j/k/l.
" (Ctrl-l no longer redraws the screen; use :redraw!.)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Split windows. <Bar> is needed because a literal | ends the mapping.
nnoremap <leader>-     :split<CR>
nnoremap <leader><Bar> :vsplit<CR>

" Previous window / close window.
nnoremap <leader>ww <C-w>p
nnoremap <leader>wd <C-w>c

" Previous / next buffer. S-h and S-l shadow H and L (top / bottom of screen).
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
nnoremap [b    :bprevious<CR>
nnoremap ]b    :bnext<CR>

" Switch to the alternate buffer / delete the current buffer.
nnoremap <leader>bb :e #<CR>
nnoremap <leader>bd :bdelete<CR>

" ---------------------------------------------------------------
" 12. General mappings
" ---------------------------------------------------------------
" Y yanks to the end of the line, like D and C (default: same as yy).
nnoremap Y y$

" Keep the selection after indenting with < or > in visual mode.
vnoremap < <gv
vnoremap > >gv

" Alt-j / Alt-k move the line (or selection) down / up and re-indent it.
nnoremap <silent> <M-j> :<C-u>execute 'move .+' . v:count1<CR>==
nnoremap <silent> <M-k> :<C-u>execute 'move .-' . (v:count1 + 1)<CR>==
inoremap <silent> <M-j> <Esc>:move .+1<CR>==gi
inoremap <silent> <M-k> <Esc>:move .-2<CR>==gi
xnoremap <silent> <M-j> :<C-u>execute "'<,'>move '>+" . v:count1<CR>gv=gv
xnoremap <silent> <M-k> :<C-u>execute "'<,'>move '<-" . (v:count1 + 1)<CR>gv=gv

" Ctrl-s saves from any mode and returns to normal mode.
" Needs `stty -ixon` in ~/.bashrc, otherwise the terminal freezes on Ctrl-s.
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>
xnoremap <silent> <C-s> <Esc>:w<CR>
snoremap <silent> <C-s> <Esc>:w<CR>

" Quit all windows.
nnoremap <leader>qq :qa<CR>

" Forgot sudo? :w!! saves the file as root.
cnoremap w!! w !sudo tee % >/dev/null

" ---------------------------------------------------------------
" 13. fzf (fzf.vim)
" ---------------------------------------------------------------
" Needs: fzf, the fzf and fzf.vim plugins in ~/.vim/pack/plugins/start/,
" and ripgrep (for :Rg and :RG).
"
" Mappings (<leader> = Space):
"   Space Space / Space ff   files in the working directory
"   Space fg                 git-tracked files
"   Space fr                 recent files
"   Space fb / Space ,       open buffers
"   Space / / Space sg       live ripgrep (updates as you type)
"   Space sw                 grep the word under the cursor
"   Space sb                 lines in the current buffer
"   Space sC                 commands
"   Space sm                 marks
"   Space sk                 key mappings
"   Space sh                 help tags
"   Space :                  command history
"   Space gc                 git commits
"   Space gs                 git status (changed files)
"
" Inside any fzf window:
"   Enter / Ctrl-x / Ctrl-v / Ctrl-t   open here / split / vsplit / tab
"   Tab                                select multiple entries
"   Ctrl-j / Ctrl-k                    move down / up
"   Esc                                close

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

" Files (all from the working directory)
nnoremap <leader><space> :Files<CR>
nnoremap <leader>ff      :Files<CR>
nnoremap <leader>fg      :GFiles<CR>
nnoremap <leader>fr      :History<CR>
nnoremap <leader>fb      :Buffers<CR>
nnoremap <leader>,       :Buffers<CR>

" Search
nnoremap <leader>/       :RG<CR>
nnoremap <leader>sg      :RG<CR>
nnoremap <leader>sw      :Rg <C-r><C-w><CR>
nnoremap <leader>sb      :BLines<CR>
nnoremap <leader>sC      :Commands<CR>
nnoremap <leader>sm      :Marks<CR>
nnoremap <leader>sk      :Maps<CR>
nnoremap <leader>sh      :Helptags<CR>
nnoremap <leader>:       :History:<CR>

" Git
nnoremap <leader>gc      :Commits<CR>
nnoremap <leader>gs      :GFiles?<CR>

" ---------------------------------------------------------------
" 14. LazyGit popup
" ---------------------------------------------------------------
" <leader>gg opens lazygit in a centered popup with rounded borders.
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

" Called when lazygit exits: close the popup, wipe the terminal buffer,
" and reload files that lazygit changed on disk.
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
