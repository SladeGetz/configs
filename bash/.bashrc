#
# ~/.bashrc
# Slade Getz
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

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
set +u

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

HISTTIMEFORMAT='%F %T '
HISTSIZE=10000
HISTFILESIZE=10000
PROMPT_DIRTRIM=3
EDITOR=nvim
ELECTRON_OZONE_PLATFORM_HINT=wayland

function __prompt() {
    local EXIT="$?"
    local psym="\$"
    local name="\[${pink}\]\u\[${NC}\]"
    local inGIT=""
    local virtENV=""
   
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
    
    if [[ -v VIRTUAL_ENV_PROMPT ]]; then 
        local snake=$'\Uf3e2'
        virtENV="\[${green}\]$snake $VIRTUAL_ENV_PROMPT\[${NC}\]"
    elif [[ -v CONDA_DEFAULT_ENV ]]; then 
        local snake=$'\Ue579'
        local condaENV="$(echo $CONDA_DEFAULT_ENV \
        | awk '{print ($1 ~ "/")? gensub(/.*\//, "", 1):$1}')"
        virtENV="\[${green}\]$snake ($condaENV)\[${NC}\]"
    fi
                    
    local prompt="${EXIT}${virtENV}[${name}@\[${pblue}\]\h\[${NC}\]]\w ${inGIT}"
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
if [[ -f ~/.bash_alias ]]; then
    . ~/.bash_alias
fi

# FUNCTIONS
if [[ -f ~/.bash_functions ]]; then
	. ~/.bash_functions
fi

if type fastfetch &>/dev/null; then
    fastfetch #--logo redstar
fi
