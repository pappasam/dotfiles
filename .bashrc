#######################################################################
# Start tmux correctly on login
#######################################################################

alias tmux='tmux -2'
[[ $TERM != "screen"  ]] && (exec tmux new -s SR || echo "")
alias tmux='tmux -2'

#######################################################################
# Environment variables
#######################################################################

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#######################################################################
# Non-function-based aliases
#######################################################################

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Set copy/paste helper functions
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Python
alias va="source venv/bin/activate"
alias ve="virtualenv -p python3.5 venv"

# Octave
alias octave="octave --no-gui"

# Public IP
alias publicip='wget -qO - http://ipecho.net/plain ; echo'

# Git
alias g="git status"
alias gn="gnome-open"

# Regex ignore annoying directories
alias regrep="grep --perl-regexp -Ir \
--exclude=*~ \
--exclude=*.pyc \
--exclude=*.csv \
--exclude=*.tsv \
--exclude=*.md \
--exclude-dir=.bzr \
--exclude-dir=.git \
--exclude-dir=.svn \
--exclude-dir=node_modules \
--exclude-dir=venv"

#######################################################################
# Function-based aliases
#######################################################################

# Colored cat
function cats() {
  pygmentize -g $1 | less -r
}

#######################################################################
# Change directory up
#######################################################################

# Move up n directories using:  cd.. 10   cd.. dir
function cd_up() {
  pushd . >/dev/null
  case $1 in
    *[!0-9]*)                                          # if no a number
      cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )     # search dir_name in current path, if found - cd to it
      ;;                                               # if not found - not cd
    *)
      cd $(printf "%0.0s../" $(seq 1 $1));             # cd ../../../../  (N dirs)
    ;;
  esac
}
alias 'cd..'='cd_up'                                # can not name function 'cd..'

#######################################################################
# Set command to include git branch in my prompt
#######################################################################

COLOR_BRIGHT_GREEN="\033[38;5;10m"
COLOR_BRIGHT_BLUE="\033[38;5;115m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_PURPLE="\033[1;35m"
COLOR_ORANGE="\033[38;5;202m"
COLOR_BLUE="\033[34;5;115m"
COLOR_WHITE="\033[0;37m"
COLOR_GOLD="\033[38;5;142m"
COLOR_SILVER="\033[38;5;248m"
COLOR_RESET="\033[0m"
BOLD="$(tput bold)"

function git_color {
  local git_status="$(git status 2> /dev/null)"
  local branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  local git_commit="$(git --no-pager diff --stat origin/${branch} 2>/dev/null)"
  if [[ $git_status == "" ]]; then
    echo -e $COLOR_SILVER
  elif [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]] && \
      [[ ! -n $git_commit ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_ORANGE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  else
    echo "(no git)"
  fi
}

# Set Bash PS1
PS1_DIR="\[$BOLD\]\[$COLOR_BRIGHT_BLUE\]\w"
PS1_GIT="\[\$(git_color)\]\[$BOLD\]\$(git_branch)\[$BOLD\]\[$COLOR_RESET\]"
PS1_USR="\[$BOLD\]\[$COLOR_GOLD\]\u@\h"
PS1_END="\[$BOLD\]\[$COLOR_SILVER\]$ \[$COLOR_RESET\]"

PS1="${PS1_DIR} ${PS1_GIT}\

${PS1_USR} ${PS1_END}"

#######################################################################
# Stack
#######################################################################

GREEN=`echo -e '\033[92m'`
RED=`echo -e '\033[91m'`
CYAN=`echo -e '\033[96m'`
BLUE=`echo -e '\033[94m'`
YELLOW=`echo -e '\033[93m'`
PURPLE=`echo -e '\033[95m'`
RESET=`echo -e '\033[0m'`

load_failed="s/^Failed, modules loaded:/$RED&$RESET/;"
load_done="s/done./$GREEN&$RESET/g;"
double_colon="s/::/$PURPLE&$RESET/g;"
right_arrow="s/\->/$PURPLE&$RESET/g;"
right_arrow2="s/=>/$PURPLE&$RESET/g;"
calc_operators="s/[+\-\/*]/$PURPLE&$RESET/g;"
string="s/\"[^\"]*\"/$RED&$RESET/g;"
parenthesis="s/[{}()]/$BLUE&$RESET/g;"
left_blacket="s/\[\([^09]\)/$BLUE[$RESET\1/g;"
right_blacket="s/\]/$BLUE&$RESET/g;"
no_instance="s/^\s*No instance/$RED&$RESET/g;"
interactive="s/^<[^>]*>/$RED&$RESET/g;"

function stack_ghci() {
    stack ghci ${1+"$@"} 2>&1 |\
      sed "$load_failed\
	   $load_done\
	   $no_instance\
	   $interactive\
	   $double_colon\
	   $right_arrow\
	   $right_arrow2\
	   $parenthesis\
	   $left_blacket\
	   $right_blacket\
	   $double_colon\
	   $calc_operators\
	   $string"
}

#######################################################################
# Load sensitive commands
#######################################################################

if [ -f ~/.bash/sensitive ]; then
  source ~/.bash/sensitive
fi