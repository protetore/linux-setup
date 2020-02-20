#!/usr/bin/env bash
#
# APT-FAST wrapper to apt-get 
# Enables fast parallel downloads with multple connections per package
#

install() {
    sudo add-apt-repository -y ppa:apt-fast/stable
    sudo apt-get update
    sudo apt-get -y install apt-fast
}

activate() {

}

uninstall() {

}