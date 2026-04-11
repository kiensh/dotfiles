autoload -Uz compinit
compinit -u

# fzf zsh integration
[[ $(command -v fzf) ]] && source <(fzf --zsh)

# function _ng() { source <(ng completion script); }
# [[ $(command -v ng) ]] && compdef _ng ng

function _npm() { source <(npm completion); }
[[ $(command -v npm) ]] && compdef _npm npm
