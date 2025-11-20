# cd backward shortcuts
function ..() { cd ..; }
function ...() { cd ../..; }
function ....() { cd ../../..; }

# Test Your Shell Load Time
function time_shell() {
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
function J() {
    dirs=$(find . -mindepth 1 -maxdepth 4 -type d)
    if [[ -z $dirs ]]; then
        echo "No directories found in the specified paths."
        return 1
    fi
    cd "$(echo "$dirs" | fzf --height 40% --reverse --border || pwd)"
}

# Update zsh plugins
function update_zsh_plugins() {
    if [[ -z $ZSH ]]; then
        echo "ZSH variable is not set."
        return 1
    fi
    for plugin_path in $ZSH/*/; do
        if [[ -d $plugin_path/.git ]]; then
            local GREEN='\033[0;32m'
            local NC='\033[0m'
            echo "${GREEN}Updating \"$(basename $plugin_path)\"...${NC}"
            git -C $plugin_path pull --rebase --autostash
        fi
    done
}

# kill port
function kill_port() {
    if [ -z "$1" ]; then
        echo "Usage: kill_port <port_number>"
        return 1
    fi
    # check if port is in use or not
    if ! lsof -i tcp:$1 >/dev/null; then
        echo "Port $1 is not in use."
        return 0
    fi
    lsof -i tcp:$1 | awk 'NR>1 {print $2}' | xargs kill -9
    echo "Successfully killed port $1."
}
