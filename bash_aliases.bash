# Add colors to linux terminal
TERM="xterm-256color"

# Make vim the default text editor
EDITOR="vim"

# Command history longer and better formatting
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%d.%m.%y %T "

# Avoid duplicates in history
export HISTCONTROL=ignoredups:erasedups

# Expand the bang command before running it
shopt -s histverify

# Fix bash history in tmux sessions by appending to history file
shopt -s histappend

# Ensures common history for all sessions
export PROMPT_COMMAND='history -a'

# Changes the terminal colors a bit
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$UID" = 0 ]; then 
    BP_USR="\[\e[1;31m\]\u\[\e[1;36m\]"; 
else
    BP_USR="\[\e[36m\]\u\[\e[m\]"; 
fi

BP_JOBS="\[\e[1;31m\]\j\[\e[m\]"; 
BP_TIME="\[\e[35m\]\t\[\e[m\]"
BP_HOST="\[\e[32m\]\h\[\e[m\]"
BP_PATH="\[\e[33;1m\]\w\[\e[m\]"
BP_BRANCH="\[\e[33m\]\$(parse_git_branch)\[\e[m\]"

export PS1="[${BP_TIME}][${BP_JOBS}] ${BP_USR}@${BP_HOST}:${BP_PATH}${BP_BRANCH}$ "

# Extract any archive by just writing "extract"
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# Alias vi to vim
alias vi="vim"

# Make moving and copying files default, without any noob interactives 
alias cp="cp"
alias mv="mv"

# Alias shorthands
alias ls="ls --color"
alias la="ls -a --color"
alias l="ls --color"
alias ll="ls -la --color"
alias lr="ls -R --color"

# Alias for calulation tool
alias calc="bc"

# Tmux aliases
_amux() {
    tmux at -t ${1:-0}
}
_nmux() {
    tmux new -s ${1:-0}
}
alias amux=_amux
alias nmux=_nmux
alias lmux="tmux ls"

# Recursive grep with perl regexes
alias grip="grep -riPHn"
alias grp="grep -nHr"

#Find
_fnd() {
    if [ -z "$1" ]; then
        echo "Usage: fnd <regex>";
        echo "Usage: fnd <path> <regex>";
    else
        if [ -z "$2" ]; then
            find . -type f -regextype posix-egrep -regex ${1}
        else
            find ${1} -type f -regextype posix-egrep -regex ${2}
        fi
    fi
}
alias fnd=_fnd

# Aliases for going up the directory

repeat() { printf "$1"'%.s' $(eval "echo {1.."$(($2))"}");  }

for i in {1..20}; do
    a=$(repeat '.' $i)
    d=$(repeat '../' $i)
    
    alias .$a="cd ${d}"
    alias .$i="cd ${d}"
done

# cdd allows you to cd to the directory of the given file or directory
# Use bash built in completion for cd to allow for filenames to be used
function cdd() {
    if [[ $# -eq 0 ]]; then
        builtin cd
    elif [[ -d "$*" ]]; then
        builtin cd "$*"
    elif [[ -f "$*" ]]; then
        local d=$(dirname "$*")
        local f=$(basename "$*")
        builtin cd "$d"
        $EDITOR "$f"
    else
        builtin cd "$*"
    fi
}
alias cd="cdd"
complete -r cd

# Disable ctrl-s to suspend
stty -ixon
