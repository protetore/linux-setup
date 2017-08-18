# Linux Customizarion

My current list of customization done on a Debian distro.

## Automation

You can execute the *setup.sh* script found on this folder/gist:

```sh
bash setup.sh
```

## Gnome shell extensions

- Activities Configurator [https://extensions.gnome.org/extension/358/activities-configurator/]
- Alternate Tab [https://extensions.gnome.org/extension/15/alternatetab/]
- Todo.txt [https://extensions.gnome.org/extension/570/todotxt/]
- Dynamic Top Bar [https://extensions.gnome.org/extension/885/dynamic-top-bar/]
- Native Window Placement [https://extensions.gnome.org/extension/18/native-window-placement/
- User Themes [https://extensions.gnome.org/extension/19/user-themes/]

## Theme

**Current**
- GTK Theme: Adapta Nokto (sudo apt install adapta-gtk-theme)
- Shell Theme: Adapta Nokto (sudo apt install adapta-gtk-theme)
- Icons: Numix Square Light (sudo apt install numix-icon-theme-square)

**Optional**
- GTK Theme: Numix Dark (sudo apt install numix-gtk-theme) [https://numixproject.org]
- Gnome Shell Theme: Numix (sudo apt install numix-gtk-theme) [https://numixproject.org]
- Icons: Numix Circle Light (sudo apt install numix-icon-theme-circle) [https://numixproject.org]

## Dock

**docky** with:
- Transparent Theme
- Recent Documents
- Weather

## Terminal

Flat Terminal Colors with Freya Theme [https://github.com/Mayccoll/Gogh]
- `wget -O gogh https://git.io/vQgMr && chmod +x gogh && ./gogh && rm gogh`
- `wget -O xt  http://git.io/v3D4o && chmod +x xt && ./xt && rm xt`

Tilda Drop Down Terminal
- https://github.com/lanoxx/tilda
- `sudo apt install tilda`
- byobu as starting cmd

## Fonts

Development: **FiraCode**

## Monitor Color Warmith

```sh
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install fluxgui
```

## Browsers

- **Firefox**
  - VivaldiFox Add-on:
    - Dark Theme
    - Use Astralis Tab = False
    - Use page colors UI = False
    
- **Opera**

## Comand Aliases

Helpful git aliases (see bash_profile for referenced functions):

```sh
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
```

## Custom Promt

Display the git branch on terminal prompt:

```sh
export PS1="\u@\h \[\033[1;34m\]\W\[\033[33m\]\$(git_branch)\[\033[00m\] $ "
```