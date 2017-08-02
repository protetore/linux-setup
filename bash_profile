# Display git branch in the prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# History search shorcuts (arrow keys)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e0A": history-search-backward'
bind '"\e0B": history-search-forward'

# Docker local dev network so containers can communicate by name
export DOCKER_NET=dev
alias drun="docker run --net=$DOCKER_NET --dns-search=$DOCKER_NET"

