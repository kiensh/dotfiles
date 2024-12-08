#!/bin/bash

mkdir -p $HOME/.config
mkdir -p $HOME/scripts
mkdir -p $HOME/backup
mkdir -p $HOME/.local/bin

for dir in config/*; do
    [ ! -d $dir ] && continue
    dir=${dir#config/}
    mkdir -v $HOME/.config/$dir
done

stow -v --adopt --target $HOME home
stow -v --adopt --target $HOME/.config config
stow -v --adopt --target $HOME/scripts scripts
stow -v --adopt --target $HOME/backup backup
stow -v --adopt --target $HOME/.local/bin bin
