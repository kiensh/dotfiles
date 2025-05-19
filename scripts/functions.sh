
# Test Your Shell Load Time
function time-shell() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# yazi
function y() {
    # local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    # yazi "$@" --cwd-file="$tmp"
    # if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    #     builtin cd -- "$cwd"
    # fi
    # rm -f -- "$tmp"
    yazi "@"
    printf "\033[4 q" # change cursor style to underline steady
}

# Typing Test toipe
function toipe() {
}

