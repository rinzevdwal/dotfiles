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

" Use the system clipboard as default
set clipboard=unnamedplus
