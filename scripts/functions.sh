# cd backward shortcuts
function ..() { cd ..; }
function ...() { cd ../..; }
function ....() { cd ../../..; }

# Test Your Shell Load Time
function time-shell() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# yazi
function yazi() {
    /opt/homebrew/bin/yazi "$@"
    printf "\033[4 q" # change cursor style to underline steady
}

# Typing Test toipe
function toipe() {
    /opt/homebrew/bin/toipe "$@"
    printf "\033[4 q" # change cursor style to underline steady
}

# jumping to a directory
function j() {
    cd "$(fzf_favorites || pwd)"
}

# Update zsh plugins
function update_zsh_plugins() {
    if [[ -z $ZSH ]]; then
        echo "ZSH variable is not set."
        return 1
    fi
    for plugin_path in $ZSH/*/; do
        if [[ -d $plugin_path/.git ]]; then
            echo "Updating $(basename $plugin_path)..."
            git -C $plugin_path pull --rebase --autostash
        fi
    done
}
