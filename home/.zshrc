
# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# starship
[[ -x /opt/homebrew/bin/starship ]] && eval "$(starship init zsh)"

### ZSH CONFIGURATION ###
if [[ -d "$HOME/scripts" ]]; then
    for script in $HOME/scripts/*.{sh,zsh}; do
        [[ -x $script ]] && source $script
    done
fi


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/kien/.lmstudio/bin"
