
export EDITOR="nvim"
export BROWSER="firefox"
export ZDOTDIR="$HOME"
export ZSH="$HOME/.zsh"
mkdir -p "$ZSH"

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

