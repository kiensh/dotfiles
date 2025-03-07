#!/bin/bash

[[ -z $@ ]] && echo "Error: No arguments provided" 1>&2 && exit 1

for file in $@; do
    echo "Copying $file to $1"
done
