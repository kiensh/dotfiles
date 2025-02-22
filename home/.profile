
export EDITOR="nvim"
export BROWSER="firefox"
export ZDOTDIR="$HOME"
export ZSH="$HOME/.zsh"
mkdir -p "$ZSH"

# Color for Linux
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33:cd=1;33:su=37;41:sg=30;43:tw=31:ow=31"
# Color for BSD (Mac OS X)
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LSCOLORS="ExGxFxDxCxDxDxhbadbxbx"

[ -d "$HOME/.local/bin" ] && export PATH+=":$HOME/.local/bin"

# dotnet
if [ -d "$HOME/dotnet" ]; then
    export DOTNET_ROOT="$HOME/dotnet"
    export PATH="$PATH:$HOME/dotnet"
    [ -d "$HOME/.dotnet/tools" ] && export PATH="$PATH:$HOME/.dotnet/tools"
fi

# rclone
[ -d "$HOME/rclone" ] && export PATH="$PATH:$HOME/rclone"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# flutter
if [ $(command -v flutter) ]; then
    export PATH="$PATH:$HOME/.pub-cache/bin"
fi

# jdk
export JAVA_HOME="/Library/Java/JavaVirtualMachines/oracle-jdk-21.0.3"
export PATH="$PATH:/Library/Java/JavaVirtualMachines/oracle-jdk-21.0.3/bin"
export CPPFLAGS="-I/Library/Java/JavaVirtualMachines/oracle-jdk-21.0.3/include"

# kubectl
if [ $(command -v kubectl) ]; then
    export KUBECONFIG="$HOME/.kube/config.yml"
fi

