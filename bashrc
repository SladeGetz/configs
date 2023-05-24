#-------------------------
# Source Global Definitions
#-------------------------

if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi


if [[ -f  /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


#-------------------------
# Completions
#-------------------------
#if [[ -f ~/.bash_completion/alacritty ]]; then
#    source ~/.bash_completion/alacritty
#fi

#---------
# COLORS
#---------
red="$(tput setaf 196)"
turquoise="$(tput setaf 45)"
green="$(tput setaf 42)"
pblue="$(tput setaf 183)"
orange="$(tput setaf 208)"
magenta="$(tput setaf 135)"
pink="$(tput setaf 219)"
NC="$(tput sgr0)"          
#---------------
# Some settings
#---------------

ulimit -S -c 0		# Don't want any coredumps
set -o notify
#set -o noclobber
set -o vi
set -o ignoreeof
set -o nounset
set -o pipefail
#set -o xtrace          # useful for debuging

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s cmdhist
#shopt -s histappend histreedit histverify
shopt -s extglob	# necessary for programmable completion
#shopt -s nocaseglob
#shopt -s globstar

# set ENV
TERM=rxvt-256color
PATH=$PATH:/Users/slade_m1/.local/bin
HISTTIMEFORMAT='%F %T '
HISTSIZE=10000
HISTFILESIZE=10000
PROMPT_DIRTRIM=3
EDITOR=nvim

function __prompt() {
    local EXIT="$?"
    local psym="\$"
    local name="\[${pink}\]\u\[${NC}\]"
    local inGIT=""
    local condaENV=""
   
    if [[ $(id -u) == "0" ]]; then
        psym="#"
        name="\[${red}\]\u\[${NC}\]"
    fi
        
    if [[ ${EXIT} != "0" ]]; then
        EXIT="\[${orange}\]${EXIT}\[${NC}\] "
    else
        EXIT=""
    fi
    
    if [[ $(git rev-parse --git-dir 2>/dev/null) ]]; then
        inGIT="(\[${turquoise}\]$(git branch --show-current)\[${NC}\]) "
    fi
    
    [ -v CONDA_DEFAULT_ENV ] && condaENV="(\[${green}\]$CONDA_DEFAULT_ENV\[${NC}\]) "
                    
    local prompt="${EXIT}${condaENV}[${name}@\[${pblue}\]\h\[${NC}\]]\w ${inGIT}"
   # printf '%s\n' "${prompt@P}"

    local prompt_length=$(echo "${prompt@P}" | wc -c)
    local two=2

    if [[ $(( ${prompt_length} / two)) -gt $((COLUMNS / two)) ]]; then
        PS1="${prompt}\n${psym} "
    else
        PS1="${prompt}${psym} "
    fi
}
PROMPT_COMMAND=__prompt

# ALIASES
# . ~/myScripts/.config_alias.sh 1
if [[ -f ~/.bash_alias ]]; then
    . ~/.bash_alias
fi

# FUNCTIONS
if [[ -f ~/.bash_functions ]]; then
	. ~/.bash_functions
fi

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

trap nnn_cd EXIT


if type fastfetch &>/dev/null; then
    fastfetch #--logo redstar
fi


