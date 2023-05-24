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

function ssh-best-keygen() {
  ssh-keygen -t ed25519 -a 100 -f "$1" -C ""
}

function act-conda() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
          . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
      else
          export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

#  . /opt/anaconda3/bin/activate
#  if [ -n "${1-}" ]
#  then
#    conda activate "$1"
#  fi
}

function act-cargo() {
  . "$HOME/.cargo/env"  
}

function getActiveInterfaces() {
  if [ "$#" -eq 0 ]; then
    ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'
  elif [[ ( "$#" -eq 1 ) && ( "$1" == '--name' ) ]]; then
    ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active' | egrep -o  '^[^\t:]+' | egrep -v '^[[:space:]]' | sed 'N;$!N;s/\n/, /g'
  else
    echo INCORRECT USAGE 
  fi
}

function resetInterfaces() {
  local interList=()
  if [[ "$#" -eq 0 ]]; then 
    interList=$(getActiveInterfaces --name)
    interList=("${(@s/, /)interList}")
  else
    interList=("$@")
  fi

  for interface in $interList; do
    if sudo ifconfig $interface down; then
      echo $interface '\t\t'SUCCESFULLY SHUTDOWN
    fi
  done
  echo '\n'
  for interface in $interList; do
    if sudo ifconfig $interface up; then
      echo $interface '\t\t'SUCCESFULLY STARTED
    fi
  done
}

function m4aTomp3() {
	if [[ "$#" -eq 0 ]]; then
		read infile
	else
		infile="$1"
	fi
	name="${infile::-4}"
	ext="${infile:(-3)}"

	if [[ "$ext" != "m4a" ]]; then
		echo incorrect input format
		return 1
	fi

	if [[ "$#" -eq 2 ]]; then
		outfile="$2"
	else
		outfile="${name}.mp3"
	fi

	ffmpeg -i $infile -codec:a libmp3lame -qscale:a 1 $outfile
	return 0
}
