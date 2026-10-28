" ===============================================================
" .vimrc  (<leader> is Space; keybindings follow LazyVim where Vim allows)
" ===============================================================
" Overview of all sections:  :g/^" ---- /p

" ---- Encoding -------------------------------------------------
" Must come first so the rest of the file is read as UTF-8.
set encoding=utf-8
scriptencoding utf-8

" ---- Vim defaults ---------------------------------------------
" Vim skips its built-in defaults (syntax on, filetype plugin indent on,
" incsearch, wildmenu, scrolloff=5, ttimeout, last cursor position, ...)
" as soon as a ~/.vimrc exists, so load them explicitly. Keep this above
" your own settings so that yours override them.
source $VIMRUNTIME/defaults.vim

" ---- Leader key -----------------------------------------------
" Prefix for custom mappings (default \). Must be set before any
" <leader> mapping in this file.
let mapleader = " "

" ---- Appearance -----------------------------------------------
" 24-bit colors in the terminal (the Catppuccin theme only defines
" GUI colors, so it needs this).
set termguicolors
colorscheme catppuccin_mocha

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

" ---- Statusline (Catppuccin Mocha) ----------------------------
" Layout: [MODE] branch | file flags ........ filetype  percent  line:col
" The mode block changes color per mode, like lualine in LazyVim.
" Inactive windows only show the file name.

" Always show the statusline, and hide Vim's own "-- INSERT --" message
" because the mode is shown in the statusline now.
set laststatus=2
set noshowmode

" Mode -> [label, highlight group]. Keyed by the first character of mode().
let s:modes = {
      \ 'n':    ['NORMAL',  'StlNormal'],
      \ 'i':    ['INSERT',  'StlInsert'],
      \ 'v':    ['VISUAL',  'StlVisual'],
      \ 'V':    ['V-LINE',  'StlVisual'],
      \ "\<C-v>": ['V-BLOCK', 'StlVisual'],
      \ 's':    ['SELECT',  'StlVisual'],
      \ 'S':    ['S-LINE',  'StlVisual'],
      \ 'R':    ['REPLACE', 'StlReplace'],
      \ 'c':    ['COMMAND', 'StlCommand'],
      \ 't':    ['TERMINAL', 'StlTerminal'],
      \ }

" Colors: Catppuccin Mocha. Mode blocks use dark text on an accent color.
"   mantle #181825   surface0 #313244   overlay0 #6c7086   text #cdd6f4
"   blue #89b4fa  green #a6e3a1  mauve #cba6f7  red #f38ba8
"   peach #fab387  teal #94e2d5
function! s:StatuslineColors() abort
  highlight StatusLine   guifg=#cdd6f4 guibg=#181825 gui=NONE cterm=NONE
  highlight StatusLineNC guifg=#6c7086 guibg=#181825 gui=NONE cterm=NONE
  highlight StatusLineTerm   guifg=#cdd6f4 guibg=#181825 gui=NONE cterm=NONE
  highlight StatusLineTermNC guifg=#6c7086 guibg=#181825 gui=NONE cterm=NONE
  highlight StlMid       guifg=#cdd6f4 guibg=#313244 gui=NONE
  highlight StlNormal    guifg=#1e1e2e guibg=#89b4fa gui=bold
  highlight StlInsert    guifg=#1e1e2e guibg=#a6e3a1 gui=bold
  highlight StlVisual    guifg=#1e1e2e guibg=#cba6f7 gui=bold
  highlight StlReplace   guifg=#1e1e2e guibg=#f38ba8 gui=bold
  highlight StlCommand   guifg=#1e1e2e guibg=#fab387 gui=bold
  highlight StlTerminal  guifg=#1e1e2e guibg=#94e2d5 gui=bold
endfunction

" Builds the statusline for the window being drawn.
" g:statusline_winid is the window Vim is currently drawing the line for.
function! Statusline() abort
  if g:statusline_winid != win_getid()
    return ' %f %m'
  endif

  let [l:label, l:group] = get(s:modes, mode()[0], ['NORMAL', 'StlNormal'])
  " Branch name from vim-fugitive; % is escaped for the statusline format.
  let l:head = exists('*FugitiveHead') ? FugitiveHead() : ''
  let l:branch = empty(l:head) ? '' : substitute(l:head, '%', '%%', 'g') . " \u2502 "
  return '%#' . l:group . '# ' . l:label . ' '
        \ . '%#StlMid# ' . l:branch . '%f%m%r%h%w '
        \ . '%#StatusLine#%='
        \ . '%#StlMid# %{&filetype} '
        \ . '%#' . l:group . '# %p%% '
        \ . '%#' . l:group . '# %l:%c '
endfunction

set statusline=%!Statusline()

" Apply the colors now, and again whenever a colorscheme is (re)loaded,
" because every colorscheme starts with `hi clear`.
call s:StatuslineColors()
augroup my_statusline
  autocmd!
  autocmd ColorScheme * call s:StatuslineColors()
augroup END

" ---- Whitespace markers ---------------------------------------
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

" ---- Terminal and timing --------------------------------------
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

" ---- Indentation and formatting -------------------------------
" Default: 4 spaces per indent level, Tab inserts spaces.
" softtabstop=-1 follows shiftwidth (vim-sleuth adjusts shiftwidth per file).
set expandtab shiftwidth=4 softtabstop=-1

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

" ---- Editing --------------------------------------------------
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

" ---- Searching ------------------------------------------------
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

" ---- Files, undo and swap -------------------------------------
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

" ---- Windows and buffers --------------------------------------
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

" Deleta all vuffers except the current one.
nnoremap <leader>bo :%bdelete <Bar> edit # <Bar> bdelete #<CR>

" ---- General mappings -----------------------------------------
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

" ---- fzf (fzf.vim) --------------------------------------------
" Needs: fzf, the fzf and fzf.vim plugins in ~/.vim/pack/plugins/start/,
" and ripgrep (for :Rg and :RG).
"
" Inside any fzf window:
"   Enter / Ctrl-x / Ctrl-v / Ctrl-t   open here / split / vsplit / tab
"   Tab                                select multiple entries
"   Ctrl-j / Ctrl-k                    move down / up
"   Esc                                close
"
" The mappings are documented in the which-key section at the end.

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

" Git (fzf pickers)
nnoremap <leader>gc      :Commits<CR>
nnoremap <leader>gs      :GFiles?<CR>

" ---- LazyGit popup --------------------------------------------
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

" ---- Git signs (vim-signify) ----------------------------------
" Always reserve the sign column so the text doesn't shift when signs appear.
set signcolumn=yes

" Git signs: a thin bar like LazyVim's gitsigns.
let g:signify_sign_add               = "\u258e"
let g:signify_sign_change            = "\u258e"
let g:signify_sign_delete            = "\u2581"
let g:signify_sign_delete_first_line = "\u2594"

" Signify links its signs to DiffAdd/DiffChange/DiffDelete, which in the
" Catppuccin theme are solid colored blocks. Use colored foreground only.
function! s:SignifyColors() abort
  highlight SignifySignAdd          guifg=#a6e3a1 guibg=NONE
  highlight SignifySignChange       guifg=#f9e2af guibg=NONE
  highlight SignifySignDelete       guifg=#f38ba8 guibg=NONE
  highlight SignifySignChangeDelete guifg=#f9e2af guibg=NONE
endfunction
call s:SignifyColors()
augroup my_signify
  autocmd!
  autocmd ColorScheme * call s:SignifyColors()
augroup END

" Jump between changed hunks.
nmap ]h <plug>(signify-next-hunk)
nmap [h <plug>(signify-prev-hunk)

" Hunk actions: preview, undo, diff the whole file.
nnoremap <leader>ghp :SignifyHunkDiff<CR>
nnoremap <leader>ghr :SignifyHunkUndo<CR>
nnoremap <leader>ghd :SignifyDiff<CR>

" Hunk text object: dih deletes the hunk under the cursor, vih selects it.
omap ih <plug>(signify-motion-inner-pending)
xmap ih <plug>(signify-motion-inner-visual)

" ---- Git commands (vim-fugitive) ------------------------------
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gf :0Gclog<CR>

" ---- Which-key (vim-which-key) --------------------------------
" Pressing Space shows a popup with the available keys and the
" descriptions below. Keys missing from the dictionary still appear,
" with their command as the description. 'name' with a leading + marks
" a group of keys.
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

let g:which_key_map = {}

let g:which_key_map[' '] = 'Find files'
let g:which_key_map[','] = 'Switch buffer'
let g:which_key_map['/'] = 'Live grep (ripgrep)'
let g:which_key_map[':'] = 'Command history'
let g:which_key_map['-'] = 'Split window below'
let g:which_key_map['|'] = 'Split window right'

let g:which_key_map.f = {
      \ 'name': '+find',
      \ 'f': 'Find files',
      \ 'g': 'Git files',
      \ 'r': 'Recent files',
      \ 'b': 'Buffers',
      \ }

let g:which_key_map.s = {
      \ 'name': '+search',
      \ 'g': 'Live grep (ripgrep)',
      \ 'w': 'Grep word under cursor',
      \ 'b': 'Lines in current buffer',
      \ 'C': 'Commands',
      \ 'm': 'Marks',
      \ 'k': 'Key mappings',
      \ 'h': 'Help tags',
      \ }

let g:which_key_map.g = {
      \ 'name': '+git',
      \ 'g': 'LazyGit',
      \ 'c': 'Commits',
      \ 's': 'Changed files',
      \ 'b': 'Blame',
      \ 'd': 'Diff against index',
      \ 'l': 'Log',
      \ 'f': 'File history',
      \ 'h': {
      \   'name': '+hunks',
      \   'p': 'Preview hunk',
      \   'r': 'Reset hunk',
      \   'd': 'Diff whole file',
      \   },
      \ }

let g:which_key_map.b = {
      \ 'name': '+buffer',
      \ 'b': 'Alternate buffer',
      \ 'd': 'Delete buffer',
      \ 'o': 'Delete other buffers'
      \ }

let g:which_key_map.w = {
      \ 'name': '+window',
      \ 'w': 'Previous window',
      \ 'd': 'Close window',
      \ }

let g:which_key_map.q = {
      \ 'name': '+quit',
      \ 'q': 'Quit all',
      \ }

let g:which_key_map.e = 'File explorer (sidebar)'

" Plugins load after the vimrc, so register once startup is finished.
augroup my_which_key
  autocmd!
  autocmd VimEnter * call which_key#register('<Space>', 'g:which_key_map')
augroup END

" ---- File explorer sidebar (fern) -----------------------------
" <leader>e toggles a left sidebar rooted at the working directory, with
" every folder expanded down to the current file (like VS Code).
" Files open in the window you came from.
let g:fern#default_hidden = 1      " show dotfiles (toggle with . in the tree)

let g:fern_disable_startup_warnings = 1

" <leader>e: cwd, revealing the current file. <leader>E: directory of the current file.
nnoremap <silent> <leader>e :Fern . -drawer -reveal=% -toggle -width=35<CR>
nnoremap <silent> <leader>E :Fern %:p:h -drawer -reveal=% -toggle -width=35<CR>

function! s:FernSetup() abort
  " Open / expand / collapse
  nmap <buffer> <CR> <Plug>(fern-action-open-or-expand)
  nmap <buffer> l    <Plug>(fern-action-open-or-expand)
  nmap <buffer> h    <Plug>(fern-action-collapse)

  " Splits and tabs (same as neo-tree)
  nmap <buffer> s    <Plug>(fern-action-open:vsplit)
  nmap <buffer> S    <Plug>(fern-action-open:split)
  nmap <buffer> t    <Plug>(fern-action-open:tabedit)

  " File operations
  nmap <buffer> a    <Plug>(fern-action-new-file)
  nmap <buffer> A    <Plug>(fern-action-new-dir)
  nmap <buffer> r    <Plug>(fern-action-rename)
  nmap <buffer> d    <Plug>(fern-action-remove)
  nmap <buffer> y    <Plug>(fern-action-clipboard-copy)
  nmap <buffer> x    <Plug>(fern-action-clipboard-move)
  nmap <buffer> p    <Plug>(fern-action-clipboard-paste)

  " View
  nmap <buffer> H    <Plug>(fern-action-hidden:toggle)
  nmap <buffer> R    <Plug>(fern-action-reload:all)
  nmap <buffer> .    <Plug>(fern-action-enter)
  nmap <buffer> <BS> <Plug>(fern-action-leave)
  nnoremap <silent> <buffer> q :close<CR>

  " Keep your window navigation inside the tree.
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-l> <C-w>l
endfunction

" Icons in the tree (needs a Nerd Font in the terminal).
let g:fern#renderer = 'nerdfont'

" Color the icons by file type. Re-applied when a fern buffer opens.
augroup my_glyph_palette
  autocmd!
  autocmd FileType fern call glyph_palette#apply()
augroup END

augroup my_fern
  autocmd!
  autocmd FileType fern call s:FernSetup()
augroup END

" fern-git-status: skip the slowest or noisiest checks.
let g:fern_git_status#disable_ignored = 1      " don't mark ignored files
" let g:fern_git_status#disable_submodules = 1  " skip submodule status
" let g:fern_git_status#disable_untracked = 1   " uncomment to hide untracked files
" let g:fern_git_status#disable_directories = 1 " uncomment to hide status on folders
