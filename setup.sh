#!/bin/bash

# Regular Colors [Foreground]
NC='\033[0m' # No Color
GRAY='\033[0;37m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[0;94m'
WHITE='\033[1;37m'

decho() {
    printf "$1\n"
}

dtitle() {
    title=$(echo $1 | tr '[:lower:]' '[:upper:]')
    printf "${YELLOW}$title${NC}\n"
}

dsub() {
    printf "${CYAN}@ ${1}${NC}\n"
}

dstep() {
    printf "${NC}  - $1${NC}\n"
}

dstep2() {
    printf "${NC}    - $1${NC}\n"
}

derror() {
    printf "${RED}[ERROR] $1${NC}\n"
}

execute() {
    out=$($@)
    if [ ! $? -eq 0 ]; then
        echo -n "$out"
        exit 1
    fi
}

if [ -L $0 ];
then
    BASEDIR=$(dirname $(readlink $0))
else
    BASEDIR="$(cd "$(dirname "$0")" && pwd -P)"
fi

USER_WORKSPACE=${1-user}
JOB_WORKSPACE=${2-yourcompany.com}

echo "# ################### #"
echo "# Linux Customization #"
echo "# ~Automation Script~ #"
echo "# ################### #"
echo
dtitle "Packages Install"

# Prepare
dsub "Updating package manager..."

execute sudo apt-get update

# My tools and eye-candy
dsub "Installing basic packages..."
execute sudo apt install -y --allow-unauthenticated \
    vim \
    curl \
    tilda \
    git \
    byobu \
    docky \
    php7.0 \
    dconf-cli \
    numix-gtk-theme \
    numix-icon-theme \
    build-essential \
    dirmngr \
    owncloud-client \
    jq

# Ubuntu only
# sudo apt install -y \
#     gnome gnome-shell \
#     numix-folders \
#     numix-blue-gtk-theme \
#     opera-stable \
#     slack-desktop

# Pure debian: Needs to add opera repo
dsub "Installing Opera..."
if [ -f /etc/apt/sources.list.d/opera.list ]; then
    execute sudo touch /etc/apt/sources.list.d/opera.list
    echo "deb http://deb.opera.com/opera-stable/ stable non-free" | sudo tee -a /etc/apt/sources.list.d/opera.list
    execute sudo apt-get update
    execute sudo apt-key adv --fetch-keys http://deb.opera.com/archive.key
    execute sudo apt-get install -y opera-stable
fi

# Pure debian: Needs to add slack repo
dsub "Installing Slack..."
if [ ! $(which slack) ]; then
    execute curl -o /tmp/slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.7.1-amd64.deb
    execute sudo apt-get install -y --allow-unauthenticated /tmp/slack.deb
fi

# ###############
# Bash Tricks
# ###############

dtitle "Command Line Customizations"

dsub "Configuring bash and command aliases..."
BASH_CONFIG=""
if [ -f ~/.bash_profile ]; then
    BASH_CONFIG=~/.bash_profile
elif [ -f ~/.bash_profile ]; then
    BASH_CONFIG=~/.profile
elif [ -f ~/.bash_profile ]; then
    BASH_CONFIG=~/.bashrc
fi

if [ "$BASH_CONFIG" == "" ]; then
    derror "[ERR] Not configuring custom prompt: no config file found (.bash_profile, .profile, .bashrc)"
    exit 1
fi

if [ -f ./bash_config ]; then
    cp ./bash_config $BASH_CONFIG
    . $BASH_CONFIG
fi

$(sed -i "s/__PERSONAL__/${USER_WORKSPACE}/g" $BASH_CONFIG)
$(sed -i "s/__COMPANY__/${JOB_WORKSPACE}/g" $BASH_CONFIG)


# ###############
# Customization
# ###############

dtitle "Visual Customizations"

# Install FiraCode font
dsub "Installing FiraCode dev font..."
if [ ! -z "$(ls ~/.local/share/fonts/FiraCode*.ttf 2> /dev/null)" ]; then
    dstep "'Fira Code' already installed..."
else
    dstep "Configuring custom font 'Fira Code'..."
    mkdir -p ~/.local/share/fonts
    for type in Bold Light Medium Regular Retina; do
        execute wget -qO ~/.local/share/fonts/FiraCode-${type}.ttf \
        "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
    done
fi
fc-cache -f

# Configure Tilda
dsub "Configuring 'tilda' drop down terminal..."
if [ ! -f ~/.config/tilda/config_0 ]; then
    dstep "Tilda not configured, setting up..."
    rm -f ~/.config/tilda/*
    cp ./tilda_config ~/.config/tilda/config_0
else
    dstep "Tilda already configured"
fi

# Flat colors terminal (ex.: 33 (Dracula))
dsub "Customizing default terminal colors..."
# wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh
# wget -O xt https://git.io/v7eBS && chmod +x xt && ./xt && rm xt # Gruvbox Dark
# wget -O xt  http://git.io/vs7Ut && chmod +x xt && ./xt && rm xt # One Dark
# wget -O xt  http://git.io/v3D4z && chmod +x xt && ./xt && rm xt # Flat
# wget -O xt  http://git.io/v3D8e && chmod +x xt && ./xt && rm xt # Dracula
# Freya:
execute wget -qO xt http://git.io/v3D4o
execute chmod +x xt
execute ./xt
execute rm xt

# Icons
# http://0rax0.deviantart.com/art/Uniform-Icon-Theme-453054609
# OR
dsub "Installing custom icons..."
cd /tmp
git clone https://github.com/numixproject/numix-icon-theme-circle.git
cd numix-icon-theme-circle
execute sudo mv Numix-Circle /usr/share/icons
execute sudo mv Numix-Circle-Light /usr/share/icons
cd -
execute rm -r /tmp/numix-icon-theme-circle

# Adapta themes
dsub "Installing GTK+/GnomeShell themes..."
execute sudo apt install autoconf automake pkg-config libglib2.0-dev libgdk-pixbuf2.0-dev libsass0 libxml2-utils sassc inkscape
execute sudo gem install bundle sass
execute git clone https://github.com/tista500/Adapta.git /tmp/adapta
cd /tmp/adapta
execute ./autogen.sh
execute make
execute sudo make install
execute sudo apt purge libsass0 libxml2-utils sassc pkg-config inkscape

# Apply themes
dsub "Applying themes and icons..."
gsettings set org.gnome.shell.extensions.user-theme name "Adapta-Nokto"
gsettings set org.gnome.desktop.interface gtk-theme "Adapta-Nokto"
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
# gsettings set org.gnome.desktop.wm.preferences theme "Adwaita"

# Dark theme
if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
    mkdir -p ~/.config/gtk-3.0/settings > /dev/null 2>&1
    touch ~/.config/gtk-3.0/settings.ini
    echo "[Settings]" > ~/.config/gtk-3.0/settings.ini
    echo "gtk-application-prefer-dark-theme=1" > ~/.config/gtk-3.0/settings.ini
else
    sed -i "/gtk-application-prefer-dark-theme/d" ~/.config/gtk-3.0/settings.ini
    sed -i "/\[Settings\]/a gtk-application-prefer-dark-theme=1" ~/.config/gtk-3.0/settings.ini
fi

# Gnome-shell Extensions
# https://extensions.gnome.org/extension/358/activities-configurator/
# https://extensions.gnome.org/extension/15/alternatetab/
# https://extensions.gnome.org/extension/885/dynamic-top-bar/
# https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/
# https://extensions.gnome.org/extension/1031/topicons/
# https://extensions.gnome.org/extension/484/workspace-grid/
base_url="https://extensions.gnome.org"
gv=$(gnome-shell --version | cut -d' ' -f3)
dest="$HOME/.local/share/gnome-shell/extensions/"
EXTENSIONS=( 358 15 885 1011 1031 484 )
for ext in ${EXTENSIONS[@]}; do
    info_url="${base_url}/extension-info/?pk=${ext}&shell_version=${gv}"
    details=$(curl "$info_url")
    downUrl="${base_url}$(echo "$details" | sed -e 's/.*"download_url": "\([^"]*\)".*/\1/')"
    uuid="$(echo "$details" | sed -e 's/.*"uuid": "\([^"]*\)".*/\1/')"
    thisDest="${dest}${uuid}"
    temp=$(mktemp -d)
    trap "rm -rfv $temp" EXIT
    curl -L "$url" > "$temp/e.zip"
    unzip "$temp/e.zip" -d "$dest"
    rm -rfv "$temp"
    trap '' EXIT
    gnome-shell-extension-tool --enable-extension="$uuid"
done

# Gnome Activities Menu Icon
mkdir -p ~/Pictures/Icons
cp $BASEDIR/gnome_bar_icon.png ${HOME}/Pictures/Icons/
dconf write /org/gnome/shell/extensions/activities-config/activities-config-button-icon-path "${HOME}/Pictures/Icons/gnome_bar_icon.png"
dconf write /org/gnome/shell/extensions/activities-config/activities-config-button-no-text true
dconf write /org/gnome/shell/extensions/activities-config/activities-icon-padding 8
dconf write /org/gnome/shell/extensions/activities-config/activities-text-padding 8

# Desktop and login screen wallpapers
mkdir -p ~/Pictures/Wallpapers
cp $BASEDIR/*wallpaper* ${HOME}/Pictures/Wallpapers/
gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/Pictures/Wallpapers/death_star_wallpaper.jpg

# Autosave Session
dconf write /org/gnome/gnome-session/auto-save-session true
dconf write /org/gnome/gnome-session/auto-save-session-one-shot true

# Monitor Color Warmith
# echo "- Installing flux do control monitor color warmth..."
# execute sudo add-apt-repository ppa:nathan-renniewaldock/flux
# execute sudo apt-get update
# execute sudo apt-get install -y --allow-unauthenticated fluxgui

# [MACOS] Terminal/iTerm Flat Theme
# https://github.com/ahmetsulek/flat-terminal


# ###############
# Prog Languages
# ###############

dtitle "Development Languages/Tools"

# Install languages and it's tools
dsub "Installing php, python tools and scala..."
execute sudo apt install -y --allow-unauthenticated \
    php-all-dev \
    python-pip \
    virtualenv \
    scala

# Nodejs and nvm
dsub "Installing nodejs and nvm..."
if [ ! $(which node) ]; then
    dstep "nodejs not found, installing..."
    execute curl -sLO https://deb.nodesource.com/setup_8.x
    execute sudo -E bash setup_8.x
    execute rm setup_8.x
    execute sudo apt-get install -y nodejs
    execute curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
else
    dstep "nodejs already installed"
fi

# Install sbt
dsub "Installing sbt..."
if [ ! -f /etc/apt/sources.list.d/sbt.list ] || [ ! $(which sbt) ]; then
    dstep "sbt not found, installing..."
    execute sudo touch /etc/apt/sources.list.d/sbt.list
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    execute sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
    execute sudo apt-get update
    execute sudo apt-get install -y sbt
    # sbt -mem 4000
else
    dstep "sbt already installed"
fi

# Graphviz for graph generation
dsub "Installing graphviz..."
execute sudo apt install -y graphviz

# PHP Composer
dsub "Installing php composer..."
if [ ! -f /usr/local/bin/composer ]; then
    dstep "PHP composer not found, installing..."
    execute curl -k https://getcomposer.org/installer -o composer-setup.php
    execute php composer-setup.php
    execute rm ./composer-setup.php
    execute sudo mv ./composer.phar /usr/local/bin/composer
    execute sudo chmod +x /usr/local/bin/composer
else
    dstep "PHP composer already installed"
fi

# For python code fixing and beautify (in atom too)
dsub "Installing autopep8..."
if [ ! -f /home/$USER/.local/bin/autopep8 ]; then
    dstep "Autopep8 not found, installing..."
    execute pip install --upgrade autopep8
    execute sudo ln -s /home/$user/.local/bin/autopep8 /usr/bin/autopep8
else
    dstep "Autopep8 already installed"
fi

# For php code fixing and beautify (in atom too)
dsub "Installing php-cs-fixer..."
if [ ! -f /usr/bin/php-cs-fixer ]; then
    dstep "php-cs-fixer not found, installing..."
    execute curl -sL http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -o php-cs-fixer
    execute chmod +x php-cs-fixer
    execute sudo mv php-cs-fixer /usr/bin/
else
    dstep "php-cs-fixer already installed"
fi

# ###############
# Developer Tools
# ###############

dtitle "Developer Tools"

# Git Prompt (depends on bash-git-prompt)
dsub "Installing gitprompt..."
if [ ! -d ~/.bash-git-prompt ]; then
    dstep "gitprompt not found, installing..."
    cd ~
    execute git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
    echo "# Git Prompt" >> ~/.bash_profile
    echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bash_profile
    echo "GIT_PROMPT_THEME=Single_line_Ubuntu" >> ~/.bash_profile
    echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bash_profile
    cd -
else
    dstep "gitprompt already installed"
fi

# Idea
# Plugins: Material UI Theme, Darcula Syntax Theme, Main menu Toggle
dsub "Installing IntelliJ Idea Community..."
if [ ! -d ~/Apps/Idea ]; then
    dstep "IntelliJ Idea not found, installing..."
    execute mkdir -p ~/Apps/Idea
    execute wget -qO idea-comm.tar.gz https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC
    execute tar -xf idea-comm.tar.gz -C ~/Apps/Idea --strip 1
    execute rm idea-comm.tar.gz
else
    dstep "Intellij Idea already installed"
fi

# Atom
dsub "Installing Atom..."
if [ -z "$(which atom)" ]; then
    dstep "Atom not found, installing..."
    execute wget -qO atom-latest.deb https://atom.io/download/deb
    execute sudo dpkg -i atom-latest.deb
    execute rm atom-latest.deb
else
    dstep "Atom already installed"
fi

dsub "Configuring Atom..."

if [ -f ~/.atom/keymap.cson ]; then
    dstep "Configuring Keymap..."
    sed -E '/^# begin-protetore-linux-setup/,/^# end-protetore-linux-setup/d' /.atom/keymap.cson
    cat <<EOF >> ~/.atom/keymap.cson

# begin:protetore-linux-setup
'atom-text-editor[data-grammar~="vue"]:not([mini])':
 'tab': 'emmet:expand-abbreviation-with-tab'

'atom-text-editor[data-grammar~="css"]:not([mini])':
 'tab': 'emmet:expand-abbreviation-with-tab'

'atom-text-editor[data-grammar~="html"]:not([mini])':
 'tab': 'emmet:expand-abbreviation-with-tab'
# end:protetore-linux-setup

EOF
else
    dstep "Previous keymap configuration found"
fi

if [ -f ~/.atom/config.cson ]; then
    dstep "General configuration..."
    sed -E '/^# begin-protetore-linux-setup/,/^# end-protetore-linux-setup/d' ~/.atom/config.cson
    cat <<EOF >> ~/.atom/config.cson

# begin:protetore-linux-setup
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
# end:protetore-linux-setup
EOF

else
    dstep "Previous atom configuration found"
fi


# ###############
# Docker CE
# ###############

dtitle "Docker"

dsub "Installing Requirements..."

execute sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

dsub "Adding apt-key..."
execute apt-key adv --fetch-keys https://download.docker.com/linux/debian/gpg

dsub "Adding reository..."
repo="deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
execute sudo touch /etc/apt/sources.list.d/docker.list
echo $repo | sudo tee -a /etc/apt/sources.list.d/docker.list

dsub "Instaling docker..."
execute sudo apt-get update
execute sudo apt-get install -y docker-ce

# Use docker without sudo
dsub "Allowing user to use docker without sudo..."
execute sudo usermod -aG docker $USER
execute newgrp
execute sudo systemctl restart docker

echo
echo "# ######## #"
echo "# FINISHED #"
echo "# ######## #"
echo
