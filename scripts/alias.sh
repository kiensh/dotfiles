
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
alias lh='ls -ld .?*'
alias lA='ls -lA | grep "^d" | grep -v "total" && ls -la | grep -v "^d"'
# alias ll='ls -l'
# alias lt='ls -ltr'

alias v="nvim"

