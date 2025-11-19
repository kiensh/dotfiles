autoload -Uz compinit
compinit -u

# function _fzf() { source <(fzf --zsh); }
# [[ $(command -v fzf) ]] && compdef _fzf fzf
#
# function _ng() { source <(ng completion script); }
# [[ $(command -v ng) ]] && compdef _ng ng

function _npm() { source <(npm completion); }
[[ $(command -v npm) ]] && compdef _npm npm
