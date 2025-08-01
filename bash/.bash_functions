# functions
function binout() {
  if [ -f "$1" ]
  then
    xxd -b "$1" | cut -d: -f 2 | sed "s/  .*//; s/ //g" | tr -d "\n"
  else
    echo "File not found"
  fi
}

function gitall() {
  git add .
  if [ -n "$1" ]
  then
    git commit -m "$1"
  else
    git commit -m 'update'
  fi
  git push
}

function sleep-mode-off() {
   xset s off 
   xset -dpms
}

function sleep-mode-on() {
   xset s on 
   xset +dpms
}

function ssh-best-keygen() {
  ssh-keygen -t ed25519 -a 100 -f "$1" -C ""
}

function act-ssh-agent() {
    if [[ "$(ps x | grep -c ssh-agent)" -gt 1 ]]; then
        echo 'ssh agent already running'
        return 0
    fi

    eval "$(ssh-agent -s)"
    if [[ "$#" -eq 0 ]]; then
        ssh-add ~/.ssh/id_ed25519
    else
        ssh-add $1
    fi
}

function vm-setup() {
    sudo systemctl start virtqemud
    sudo systemctl start libvirtd
}

function act-venv() {
    if [[ "$#" -ne 1 ]]; then
        source $HOME/.venv/base/bin/activate
    else
        source $HOME/.venv/$1/bin/activate
    fi
}

function act-conda() {
    if [[ ! -n "$(env | grep conda)" ]]; then
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$HOME/pkgs/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$HOME/pkgs/miniconda3/etc/profile.d/conda.sh" ]; then
                . "$HOME/pkgs/miniconda3/etc/profile.d/conda.sh"
            else
                export PATH="$HOME/pkgs/miniconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

    elif [[ "$#" -ne 1 && $CONDA_SHLVL -gt 0 ]]; then
        return 1
    fi

    if [[ "$#" -ne 1 ]]; then
        conda activate base
    else
        local n=$(($CONDA_SHLVL - 1))
        for i in {0..n}
        do
            conda deactivate
        done
        conda activate $1
    fi
}

function deactivate-conda() {
    if [[ ! "$(env | grep -i 'conda\|CONDA')" ]]; then
        echo 'conda is not activated'
        return 1
    fi

    local n=$(($CONDA_SHLVL - 1))
    for i in {0..n}
    do
        conda deactivate
    done

    # remove conda from path
    PATH="$(awk -F: '{ for (i=1; i<=NF; ++i) if ($i !~ "conda") printf "%s:", $i } END { if (NF > 0 && $NF !~ "conda") print $NF }' <(echo $PATH))"

    # retrieve any leftover env vars
    local -a arr
    readarray -t arr <<< "$(env | grep CONDA | awk -F= '{print $1}' | cut -d' ' -f1)" 
    for env_var in "${arr[@]}"; do
        echo "unsetting $env_var"
        unset $env_var
    done
}


# nnn modify current dir
NNN_TMPFILE=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd

function n ()
{
    # Block nesting of nnn in subshells
    if [[ "${NNNLVL:-0}" -ge 1 ]]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The backslash allows one to alias n to nnn if desired without making an
    # infinitely recursive alias
    \nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

function nnn_cd()                                                                                                   
{
    if ! [[ -z "$NNN_PIPE" ]]; then
        printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" !&
    fi  
}

# trap nnn_cd EXIT

function rekernel() {
    doas mkinitcpio -p linux
    doas grub-mkconfig -o /boot/grub/grub.cfg
}
