#!/bin/bash 

_apt(){
    echo install $1
}

_pacman(){
    echo "-S" $1
}

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

case $PKG in
    apt)
        _apt "$1"
        ;;
    pacman)
        _pacman "$1"
        ;;
    *)
        echo ERROR: Unsupported package manager $PKG
        ;;
esac

