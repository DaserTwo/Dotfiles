#!/bin/bash 

# imports
. $(dirname "$0")/import.sh 2>> /dev/null 
. $(dirname "$0")/tools/import.sh 2>> /dev/null 

import log

# apt call function
_apt(){
    local pkgs=""
    for e in $@
    do
        if [ $e = 'lua' ]
        then
            pkgs+=' lua5.4'
        else
            pkgs+=" $e"
        fi 
    done
    sudo apt install $pkgs
}

# pacman call function
_pacman(){
    sudo pacman -S $@
}

# Find out package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

PKG=0 

for f in ${!osInfo[@]}
do
    if [[ -f $f ]]
    then
        PKG=${osInfo[$f]}
    fi
done

# pkgi function 
pkgi(){
    if [ -z $1 ]
    then
        log e "No package provided"
        exit 1
    fi

    case $PKG in
        apt)
            _apt "$@"
            ;;
        pacman)
            _pacman "$@"
            ;;
        *)
            log e "Unsupported package manager $PKG"
            exit 1
            ;;
    esac
}

