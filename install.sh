#!/bin/bash

#############################
# Install Configs           #
#############################

# Vars
TRUE=1
FALSE=0

if [[ "$(shopt -q extglob)" ]]; then
    RESET="$FALSE"
else
    RESET="$TRUE"
    shopt -s extglob
fi


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONFIGS="${XDG_CONFIG_HOME:-$HOME/.config}"

declare -a EXCLUDE_DIRS=("$@")
EXCLUDE_DIRS+=('git' 'flags')


cp -r $SCRIPT_DIR/flags/* $CONFIGS
for conf_dir in $(find $SCRIPT_DIR -maxdepth 1 -mindepth 1  -type d -prune | grep -vf <( echo "${EXCLUDE_DIRS[@]}" | tr ' ' '\n')); do
    # echo "${conf_dir##*/}"
    mkdir -p $CONFIGS/"${conf_dir##*/}"
    cp -r $conf_dir/!(packages) $CONFIGS/"${conf_dir##*/}"

    while read -r pkg; do
        yay -S "$pkg" --noconfirm
    done < "$conf_dir/packages"
done


if [[ "$RESET" -eq "$TRUE" ]]; then 
    shopt -u extglob
fi
