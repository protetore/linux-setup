#!/bin/bash

if [ -L $0 ];
then
    BASEDIR=$(dirname $(readlink $0))
else
    BASEDIR="$(cd "$(dirname "$0")" && pwd -P)"
fi

USER_WORKSPACE=${1-user}
JOB_WORKSPACE=${2-yourcompany.com}

echo "Packages Install"

# Prepare
echo "- Updating package manager..."
sudo apt-get update

# My tools and eye-candy
echo "- Installing basic packages..."
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
# Bash Tricks
# ###############

echo "Command Line Customizations"

echo "- Configuring bash and command aliases..."
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

if [ -f ./bash_config ]; then
    cp ./bash_config $BASH_CONFIG
    . $BASH_CONFIG
fi


# ###############
# Customization
# ###############

echo "Visual Customizations

# Install FiraCode font
echo "- Installing FiraCode dev font..."
echo "Configuring custom font 'Fira Code'..."
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
    wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
done
fc-cache -f

# Configure Tilda
echo "- Installing tilda drop down terminal..."
if [ -f ./tilda_config ]; then
    rm -f ~/.config/tilda/*
    cp ./tildaconfig ~/.config/tilda/config_0
fi

# Flat colors terminal (ex.: 33 (Dracula))
echo "- Customizing default terminal colors..."
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

# Icons
# http://0rax0.deviantart.com/art/Uniform-Icon-Theme-453054609

# Monitor Color Warmith
echo "- Installing flux do control monitor color warmth..."
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install fluxgui

# [MACOS] Terminal/iTerm Flat Theme
# https://github.com/ahmetsulek/flat-terminal

  
# ###############
# Prog Languages
# ###############

echo "Development Languages/Tools"

# Install languages and it's tools
echo "- Installing php, python tools and scala..."
sudo apt install -y php-all-dev pip virtualenv scala

# Nodejs and nvm
echo "- Installing nodejs and nvm..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

# Install sbt 
echo "- Installing sbt..."
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
sbt -mem 4000

# Graphviz for graph generation
echo "- Installing graphviz..."
sudo apt install graphviz

# PHP Composer
echo "- Installing php composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv ./composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# For python code fixing and beautify (in atom too)
echo "- Installing autopep8..."
pip install --upgrade autopep8 
sudo ln -s /home/$user/.local/bin/autopep8 /usr/bin/autopep8

# For php code fixing and beautify (in atom too)
echo "- Installing php-cs-fixes..."
curl -L http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer
chmod +x php-cs-fixer
mv php-cs-fixer /usr/bin/


# ###############
# Developer Tools
# ###############

echo "Developer Tools"

# Git Prompt (depends on bash-git-prompt)
echo "- Installing gitprompt..."
cd ~
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
echo "# Git Prompt" >> ~/.bash_profile
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bash_profile
echo "GIT_PROMPT_THEME=Single_line_Ubuntu" >> ~/.bash_profile
echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bash_profile 

# Idea
echo "- Installing IntelliJ Idea Community..."
mkdir -p ~/Apps/Idea
wget -O idea-comm.tar.gz https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC
tar -xf idea-comm.tar.gz -C ~/Apps/Idea --strip 1

# Atom
echo "- Installing Atom..."
wget -O atom-latest.deb https://atom.io/download/deb
dpkg -i atom-latest.deb


# ###############
# Atom Config
# ###############

echo "- Configuring Atom..."

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


# ###############
# Docker CE
# ###############

echo "Docker"

echo "- Installing Requirements..."

sudo apt-get install -y \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
   
echo "- Adding apt-key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "- Adding reository..."
sudo add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"

echo "- Instaling docker..."
sudo apt-get update
sudo apt-get install docker-ce

# Use docker without sudo
echo "- Allowing user to use docker without sudo..."
sudo usermod -aG docker $USER
newgrp
sudo systemctl restart docker

echo
echo "# ######## #
echo "# FINISHED #"
echo "# ######## #
echo