# #################
# Git helpers
# #################

# Ensure current branch is up-to-date with remote
git_up() {
    git pull --rebase --prune --autostash $@ git submodule update --init --recursive
}

# Update master and rebase current branch from it
git_update(){
    git checkout master && git pull && git checkout - && git rebase master
}

# Reset local only commits (keep the changes)
git_undo(){
    git reset HEAD~ --mixed
}

# Display git branch in the prompt
git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Deletes all branches already merged into master
git_clean() {
    git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -r git branch -d;
}

# Completing a work: runs git up to bring master and update it and remove branches already merged into master
git_done() {
    git checkout ${1-master} && git_up && git_clean ${1-master};
}

# Useful git aliases
alias gc='git commit -m'
alias gcm='git add -A && git commit -m'
alias gp='git pull origin $(git_branch)'
alias gcb='git checkou -b'
alias gsave='git add -A && git commit -m "SAVEPOINT"'
alias gundo='git reset HEAD~ --mixed'
alias gamend='git commit -a --amend'
alias gwipe='git add -A && git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
alias gclean='git_clean'
alias gdone='git_done'

# Git Prompt Package
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Protetore_Minimalist
source ~/.bash-git-prompt/gitprompt.sh

# #################
# Custom Prompt
# #################

export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(git_branch)\[\033[00m\] $ "

# #################
# Useful Shortcuts
# #################

# History search shorcuts (arrow keys)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e0A": history-search-backward'
bind '"\e0B": history-search-forward'

# Docker local dev network so containers can communicate by name
export DOCKER_NET=dev
alias drun="docker run --net=dev --dns-search=dev"

# Shorcuts
export W=~/Workspace/
export WORKSPACE=$W
alias w="cd $W"
alias p="cd $W/protetore.net"

# Work
export WCV=$W/commodityvectors.com/
alias wcv="cd $WCV"

# ################
# SSH
# ################

# Warning: SSH will stop warning you if server hash changes, use carefully
SSH_OPTS=" -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null "