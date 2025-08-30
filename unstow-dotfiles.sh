#!/bin/bash

stow -v -D --target $HOME home
stow -v -D --target $HOME/.config config
stow -v -D --target $HOME/scripts scripts
stow -v -D --target $HOME/backup backup
stow -v -D --target $HOME/.local/bin bin
