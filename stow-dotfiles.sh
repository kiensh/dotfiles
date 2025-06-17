#!/bin/bash

mkdir -p $HOME/.config
mkdir -p $HOME/scripts
mkdir -p $HOME/backup
mkdir -p $HOME/.local/bin

for dir in config/*; do
    [ ! -d $dir ] && continue
    dir=${dir#config/}
    mkdir -pv $HOME/.config/$dir
done

stow -v --no-folding --target $HOME home
stow -v --no-folding --target $HOME/.config config
stow -v --no-folding --target $HOME/scripts scripts
stow -v --no-folding --target $HOME/backup backup
stow -v --no-folding --target $HOME/.local/bin bin
