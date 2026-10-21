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
" Keep the selection after indenting with < or > in visual mode,
" so you can press them repeatedly.
vnoremap < <gv
vnoremap > >gv

" Forgot sudo? :w!! saves the file as root.
cnoremap w!! w !sudo tee % >/dev/null

