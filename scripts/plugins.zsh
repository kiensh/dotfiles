
# zsh-completions
[ ! -d "$ZSH/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions $ZSH/zsh-completions
fpath=($ZSH/zsh-completions/src $fpath)
# case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} = # colorz !

# zsh-autosuggestions
# [ ! -d "$ZSH/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/zsh-autosuggestions
# fpath=($ZSH/zsh-autosuggestions $fpath)
# source $ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-nvm
[ ! -d "$ZSH/zsh-nvm" ] && git clone https://github.com/lukechilds/zsh-nvm.git $ZSH/zsh-nvm
fpath=($ZSH/zsh-nvm $fpath)
NVM_COMPLETION=true
NVM_LAZY_LOAD=true
source $ZSH/zsh-nvm/zsh-nvm.plugin.zsh

# zsh-syntax-highlighting (must be last)
[ ! -d "$ZSH/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/zsh-syntax-highlighting
fpath=($ZSH/zsh-syntax-highlighting $fpath)
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function update_zsh_plugins() {
    echo "Updating zsh plugins..."
    for  plugin_path in $ZSH/*/; do
        if [[ -d $plugin_path/.git ]]; then
            echo "Updating $(basename $plugin_path)..."
            git -C $plugin_path pull --rebase --autostash
        else
            echo "$(basename $plugin_path) is not a git repository, skipping..."
        fi
    done
    echo "Plugins updated."
}
