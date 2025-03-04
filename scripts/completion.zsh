
### Using fpath ###
# homebrew
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

### Load fpath ###
autoload -Uz compinit
compinit -u

### Using Compdef ###
function _fzf() { source <(fzf --zsh); }
[[ $(command -v fzf) ]] && compdef _fzf fzf

function _ng() { source <(ng completion script); }
[[ $(command -v ng) ]] && compdef _ng ng

function _docker() { source <(docker completion zsh); }
[[ $(command -v docker) ]] && compdef _docker docker

function _kubectl() { source <(kubectl completion zsh); }
[[ $(command -v kubectl) ]] && compdef _kubectl kubectl

function _flutter() { source <(flutter bash-completion); }
[[ $(command -v flutter) ]] && compdef _flutter flutter

function _colima() { source <(colima completion zsh); }
[[ $(command -v colima) ]] && compdef _colima colima

function _helm() { source <(helm completion zsh); }
[[ $(command -v helm) ]] && compdef _helm helm

