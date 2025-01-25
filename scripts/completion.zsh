
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
function completion_fzf() {
    [[ $(command -v fzf) ]] && source <(fzf --zsh)
}

function completion_ng() {
    [[ $(command -v ng) ]] && source <(ng completion script)
}

function completion_docker() {
    [[ $(command -v docker) ]] && source <(docker completion zsh)
}
compdef completion_docker docker

function completion_kubectl() {
    [[ $(command -v kubectl) ]] && source <(kubectl completion zsh)
}
compdef completion_kubectl kubectl

function completion_flutter() {
    [[ $(command -v flutter) ]] && source <(flutter bash-completion)
}
compdef completion_flutter flutter

function completion_colima() {
    [[ $(command -v colima) ]] && source <(colima completion zsh)
}
compdef completion_colima colima
