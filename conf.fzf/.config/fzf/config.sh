# fzf configuration with catppuccin mocha theme.

export FZF_DEFAULT_OPTS="
    --layout=reverse
    --info=inline
    --height=80%
    --multi
    --ansi
    --preview-window=:hidden
    --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC 
    --color=marker:2,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 
    --color=selected-bg:#45475A 
    --color=border:#6C7086,label:#CDD6F4 
    --color=footer:3
    --prompt='❯ ' --pointer='▶' --marker='✓'
    --bind '?:toggle-preview'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
    --bind 'ctrl-v:execute(code {+})'
    --footer='?:Preview|CTRL-a:Select all|CTRL-y:Copy to clipboard|CTRL-e:Vim|CTRL-v:Code'
    "

# Use fd as search engine

FZF_FD_OPTS="--strip-cwd-prefix --hidden --follow --exclude '.git'"
export FZF_DEFAULT_COMMAND="fd --type file --color=always $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type directory $FZF_FD_OPTS"

_fzf_compgen_path() {
    fd --type file --color=always --hidden --follow --exclude '.git' . "${1}"
}

_fzf_compgen_dir() {
    fd --type directory --hidden --follow --exclude '.git' . "${1}"
}

# use ripgrep as search engine
# if which rg >/dev/null; then
#     export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
#     export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# fi
