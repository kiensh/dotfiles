
alias mpv-playlist="ls *.{mp4,mkv} | sort -V | mpv --playlist=-"
alias v="vim"

# LINUX
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=37;41:sg=30;43:tw=31:ow=31"
# BSD (Mac OS X)
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LSCOLORS="ExGxFxDxCxDxDxhbadbxbx"

alias grep='grep --color=auto'
alias ls='ls --color=always'
alias ld='ls -l | grep "^d" | grep -v "total"'
alias lf='ls -lp --color=always | grep -v "^d" | grep -v "total"'
alias lh='ls -ld .*'
alias ll='ls -lA | grep "^d" | grep -v "total" && ls -la | grep -v "^d" | grep -v "total"'
# alias ll='ls -l'
# alias lt='ls -ltr'
if [ "$(command -v eza)" ]; then
    alias ld='eza -lD --show-symlinks'
    alias lf='eza -lf --show-symlinks'
    alias lh='eza -dl .* --group-directories-first'
    alias ll='eza -la --group-directories-first'
    alias mpv-playlist="eza --no-quotes *.{mp4,mkv} | mpv --playlist=-"
fi

# Tools
[[ $(command -v nvim) ]] && alias v="nvim"
[[ $(command -v colima) ]] && alias c='colima'
[[ $(command -v docker) ]] && alias d='docker'
[[ $(command -v kubectl) ]] && alias k='kubectl'

