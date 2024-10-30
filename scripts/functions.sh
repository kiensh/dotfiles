
# function extract() {
#   for f in "$@"; do
#     case "$f" in
#       *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) echo tar xjvf "$f";;
#       *.tar.gz|*.tgz) echo tar xzvf "$f";;
#       *.tar.xz|*.txz) echo tar xJvf "$f";;
#       *.tar.zst|*.zst) echo tar xaf "$f";;
#       *.7z|*.zip) echo 7z x -o${f%.*} "$f";;
#       *.rar) echo unrar x -o- "$f";;
#     esac
#   done
# }

