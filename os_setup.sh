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
  numix-gtk-theme \
  numix-folders \
  numix-icon-theme-square \
  numix-icon-theme-circle \
  numix-icon-theme \
  numix-blue-gtk-theme \
  slack-desktop \
  build-essential

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

# Git branch on prompt
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
else    
    cat <<EOF >> $BASH_CONFIG
    parse_git_branch() {
         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    export PS1="\u@\h \[\033[1;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
    EOF
fi

  
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