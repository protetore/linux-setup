# Git helpers
git_update(){
    git checkout master && git pull && git checkout - && git rebase master
}

# Display git branch in the prompt
git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(git_branch)\[\033[00m\] $ "

# History search shorcuts (arrow keys)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e0A": history-search-backward'
bind '"\e0B": history-search-forward'

# Docker local dev network so containers can communicate by name
export DOCKER_NET=dev
alias drun="docker run --net=dev --dns-search=dev"

# Git Prompt
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Single_line_Ubuntu
source ~/.bash-git-prompt/gitprompt.sh

