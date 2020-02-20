#!/usr/bin/env bash
#
# Install Adpta Theme
#

install() {
    sudo apt-add-repository -y ppa:tista/adapta
    sudo apt -y install adapta-gtk-theme
}

activate() {

}

uninstall() {

}