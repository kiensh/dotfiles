#!/bin/bash

[[ -z $@ ]] && echo "Error: No arguments provided" 1>&2 && exit 1

echo "Copy Mode"

SELECTED=($@)
SELECTED=("${SELECTED[@]/#/\"}")
SELECTED=("${SELECTED[@]/%/\"}")

for i in "${SELECTED[@]}"; do
    echo "Selected: $i"
done

