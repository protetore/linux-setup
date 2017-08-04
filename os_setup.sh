#!/bin/bash

user=$(whoami)

sudo apt-get update

# My tools and eye-candy
sudo apt install -y vim \
  gnome gnome-shell \
  tilda \
  git \
  byobu \
  docky \
  dconf-cli \
  numix-gtk-theme \
  numix-folders \
  numix-icon-theme-square \
  numix-icon-theme-circle \
  numix-icon-theme \
  numix-blue-gtk-theme \
  slack-desktop \
  build-essential \
  opera-stable

# ###############
# Docker CE
# ###############

sudo apt-get install -y \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"
 
sudo apt-get update
sudo apt-get install docker-ce

# ###############
# Bash Tricks
# ###############

echo "Configuring custom prompt..."
BASH_CONFIG=""
if [ -f ~/.bash_profile ]; then 
    BASH_CONFIG=~/.bash_profile
elif [ -f ~/.bash_profile ]; then 
    BASH_CONFIG=~/.profile
elif [ -f ~/.bash_profile ]; then 
    BASH_CONFIG=~/.bashrc
fi

if [ "$BASH_CONFIG" == "" ]; then
    echo "[ERR] Not configuring custom prompt: no config file found (.bash_profile, .profile, .bashrc)"  
    exit 1
fi

# Easy history navigation
cat <<EOF >> $BASH_CONFIG
# History search shorcuts (arrow keys)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e0A": history-search-backward'
bind '"\e0B": history-search-forward'
EOF

# Flat colors terminal (ex.: 33 (Dracula))
wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh
wget -O xt  http://git.io/v3DR0 && chmod +x xt && ./xt && rm xt
wget -O xt  http://git.io/v3D8R && chmod +x xt && ./xt && rm xt
wget -O xt  http://git.io/v3DBT && chmod +x xt && ./xt && rm xt
wget -O xt  http://git.io/v3Dlz && chmod +x xt && ./xt && rm xt
wget -O xt  http://git.io/v3Dlm && chmod +x xt && ./xt && rm xt
wget -O xt  http://git.io/v3DBP && chmod +x xt && ./xt && rm xt
wget -O xt https://git.io/v7eBS && chmod +x xt && ./xt && rm xt # Gruvbox Dark
wget -O xt  http://git.io/vs7Ut && chmod +x xt && ./xt && rm xt # One Dark
wget -O xt  http://git.io/v3D4z && chmod +x xt && ./xt && rm xt # Flat
wget -O xt  http://git.io/v3D8e && chmod +x xt && ./xt && rm xt # Dracula
wget -O xt  http://git.io/v3D4o && chmod +x xt && ./xt && rm xt # Freya


  
# ###############
# Customization
# ###############

# Install FiraCode font
echo "Configuring custom font 'Fira Code'..."
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
    wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
done
fc-cache -f

# Configure Tilda
if [ -f ./tilda_config ]; then
    rm -f ~/.config/tilda/*
    cp ./tildaconfig ~/.config/tilda/config_0
fi

# Icons
# http://0rax0.deviantart.com/art/Uniform-Icon-Theme-453054609

  
# ###############
# CV Projects 
# ###############

# Install languages and it's tools
sudo apt install -y pip virtualenv scala

# Nodejs and nvm
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Install sbt 
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
sbt -mem 4000

# Graphviz for grapth generation
sudo apt install graphviz

# ###############
# Developer Tools
# ###############

# Git branch on prompt (no dependencies)
cat <<EOF >> $BASH_CONFIG
# Git helpers
git_update(){
    git checkout master && git pull && git checkout - && git rebase master
}
# Display git branch in the prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF

# Git Prompt (depends on bash-git-prompt)
cd ~
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
echo "# Git Prompt" >> ~/.bash_profile
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bash_profile
echo "GIT_PROMPT_THEME=Single_line_Ubuntu" >> ~/.bash_profile
echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bash_profile 

# Idea
mkdir -p ~/Apps/Idea
wget -O idea-comm.tar.gz https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC
tar -xf idea-comm.tar.gz -C ~/Apps/Idea --strip 1

# Atom
wget -O atom-latest.deb https://atom.io/download/deb
dpkg -i atom-latest.deb

# ###############
# Lang Parsers
# ###############

# For python code fixing and beautify (in atom too)
pip install --upgrade autopep8 
sudo ln -s /home/$user/.local/bin/autopep8 /usr/bin/autopep8

# For php code fixing and beautify (in atom too)
curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer
chmod +x php-cs-fixer
mv php-cs-fixer /usr/bin/

# ###############
# Atom Config
# ###############

if [ -f ~/.atom/keymap.cson ]; then
  cat <<EOF >> ~/.atom/keymap.cson
  'atom-text-editor[data-grammar~="vue"]:not([mini])':
   'tab': 'emmet:expand-abbreviation-with-tab'

  'atom-text-editor[data-grammar~="css"]:not([mini])':
   'tab': 'emmet:expand-abbreviation-with-tab'

  'atom-text-editor[data-grammar~="html"]:not([mini])':
   'tab': 'emmet:expand-abbreviation-with-tab'
EOF
fi

if [ -f ~/.atom/config.cson ]; then
  cat <<EOF >> ~/.atom/config.cson
  "*":
    "atom-beautify":
      js:
        beautify_on_save: true
      json:
        beautify_on_save: true
      less:
        beautify_on_save: true
      markdown:
        beautify_on_save: true
      nginx:
        beautify_on_save: true
      php:
        beautify_on_save: true
      python:
        beautify_on_save: true
      sass:
        beautify_on_save: true
      scss:
        beautify_on_save: true
      vue:
        beautify_on_save: true
      xml:
        beautify_on_save: true
      yaml:
        beautify_on_save: true
    core:
      autoHideMenuBar: true
      telemetryConsent: "no"
      themes: [
        "one-dark-ui"
        "firewatch-syntax"
      ]
    editor:
      fontFamily: "Fira Code"
    "exception-reporting":
      userId: "1fe51ccf-b1c7-4e08-9d74-bbe684d2fa1e"
    welcome:
      showOnStartup: false
EOF
fi

