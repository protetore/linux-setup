# Linux Customizarion

My current list of customization done on a Debian based distro.

## Automation

You can execute the _setup.sh_ script found on this folder:

```sh
bash setup.sh
```

## Customizing this Setup

- config
- scripts
- shell

## Included Customizations

### Gnome shell extensions

- Activities Configurator [<https://extensions.gnome.org/extension/358/activities-configurator/>]
- Alternate Tab [<https://extensions.gnome.org/extension/15/alternatetab/>]
- Todo.txt [<https://extensions.gnome.org/extension/570/todotxt/>]
- Dynamic Top Bar [<https://extensions.gnome.org/extension/885/dynamic-top-bar/>]
- Native Window Placement [<https://extensions.gnome.org/extension/18/native-window-placement/>
- User Themes [<https://extensions.gnome.org/extension/19/user-themes/>]

### Theme

**Current**

- GTK Theme: Adapta Nokto (on Ubuntu: sudo apt install adapta-gtk-theme)
- Shell Theme: Adapta Nokto (on Ubuntu: sudo apt install adapta-gtk-theme)
- Icons: Numix Square Light (on Ubuntu: sudo apt install numix-icon-theme-square)

```sh
# Adapta Theme
sudo apt install autoconf automake pkg-config libglib2.0-dev libgdk-pixbuf2.0-dev libsass0 libxml2-utils sassc inkscape
sudo gem install bundle sass
git clone https://github.com/tista500/Adapta.git /tmp/adapta
cd /tmp/adapta
./autogen.sh
make
sudo make install
sudo apt purge libsass0 libxml2-utils sassc pkg-config inkscape
gsettings set org.gnome.shell.extensions.user-theme name "Adapta-Nokto"
gsettings set org.gnome.desktop.interface gtk-theme "Adapta-Nokto"

# Numix Icons
cd /tmp
git clone https://github.com/numixproject/numix-icon-theme-circle.git
cd numix-icon-theme-circle
sudo mv Numix-Circle /usr/share/icons
sudo mv Numix-Circle-Light /usr/share/icons
cd -
rm -r /tmp/numix-icon-theme-circle
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"
```

**Optional**

- GTK Theme: Numix Dark (on Ubuntu: sudo apt install numix-gtk-theme) [<https://numixproject.org>]
- Gnome Shell Theme: Numix (on Ubuntu: sudo apt install numix-gtk-theme) [<https://numixproject.org>]
- Icons: Numix Circle Light (on Ubuntu: sudo apt install numix-icon-theme-circle) [<https://numixproject.org>]

### Dock

**docky** with:

- Transparent Theme
- Recent Documents
- Weather

### Terminal

Flat Terminal Colors with Freya Theme [<https://github.com/Mayccoll/Gogh>]

- `wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh` -> Choose 44
- `wget -O xt http://git.io/v3D4o && chmod +x xt && ./xt && rm xt`

Tilda Drop Down Terminal

- <https://github.com/lanoxx/tilda>
- `sudo apt install tilda`
- byobu as starting cmd

### Fonts

Development: **FiraCode**

### Monitor Color Warmith

```sh
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install fluxgui
```

### Browsers

- **Firefox**

  - VivaldiFox Add-on:

    - Dark Theme
    - Use Astralis Tab = False
    - Use page colors UI = False

- **Opera**

### Comand Aliases

Helpful git aliases (see bash_profile for referenced functions):

**Bash**

```sh
alias gc='git commit -m'
alias gcm='git add -A && git commit -m'
alias gp='git pull origin $(git_branch)'
alias gcb='git checkout -b'
alias gsave='git add -A && git commit -m "SAVEPOINT"'
alias gundo='git reset HEAD~ --mixed'
alias gamend='git commit -a --amend'
alias gwipe='git add -A && git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
alias gclean='git_clean'
alias gdone='git_done'
```

**Git** (~/.gitconfig)

```sh
[alias]
    up = !git pull --rebase --prune --autostash $@ git submodule update --init --recursive
    co = checkout
    ec = config --global -e
    cb = checkout -b
    cm = !git add -A && git commit -m
    save = !git add -A && git commit -m 'SAVEPOINT'
    wip = !git add -u && git commit -m "WIP"
    undo = reset HEAD~1 --mixed
    amend = commit -a --amend
    remaster = git remote update -p && git rebase origin/master
    wipe = !git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard
    clean = "!f() { git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -r git branch -d; }; f"
    done = "!f() { git checkout ${1-master} && git up && git bclean ${1-master}; }; f"
    change-commits = "!f() { VAR1=$1; VAR='$'$1; OLD=$2; NEW=$3; echo \"Are you sure for replace $VAR $OLD => $NEW ?(Y/N)\";read OK;if [ \"$OK\" = 'Y' ] ; then shift 3; git filter-branch --env-filter \"if [ \\\"${VAR}\\\" = '$OLD' ]; then export $VAR1='$NEW';echo 'to $NEW'; fi\" $@; fi;}; f "
```

### Custom Promt

Display the git branch on terminal prompt:

```sh
export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(git_branch)\[\033[00m\] $ "
```

### Dev Tools

- IDEs

  - Visual Studio Code
  - IntelliJ Idea Community (Plugins: Material UI Theme, Darcula Syntax Theme, Main menu Toggle)

- Langs & Tools

  - Go Lang
  - Python, pip, virtualenv, autopep8
  - NodeJS, nvm
  - PHP, php-cs-fixer, composer
  - Scala, sbt
