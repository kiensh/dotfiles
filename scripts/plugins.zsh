
# zsh-completions
[ ! -d "$ZSH/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions $ZSH/zsh-completions
fpath=($fpath $ZSH/zsh-completions/src)
# case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} = # colorz !

# zsh-autosuggestions
[ ! -d "$ZSH/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/zsh-autosuggestions
fpath=($fpath $ZSH/zsh-autosuggestions)
source $ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-nvm
[ ! -d "$ZSH/zsh-nvm" ] && git clone https://github.com/lukechilds/zsh-nvm.git $ZSH/zsh-nvm
fpath=($fpath $ZSH/zsh-nvm)
NVM_COMPLETION=true
NVM_LAZY_LOAD=true
source $ZSH/zsh-nvm/zsh-nvm.plugin.zsh

# zsh-syntax-highlighting
[ ! -d "$ZSH/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/zsh-syntax-highlighting
fpath=($fpath $ZSH/zsh-syntax-highlighting)
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf-tab
[ ! -d "$ZSH/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab $ZSH/fzf-tab
fpath=($fpath $ZSH/fzf-tab)
source $ZSH/fzf-tab/fzf-tab.zsh

