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
    	elif [ $e = 'build' ]
        then
            pkgs+=' build-essentials'
        elif [ $e = 'rust' ]
        then
            pkgs+=' rustc cargo'
        elif [ $e = 'python' ]
        then
            pkgs+=' python3'
	elif [ $e = 'librewolf' ]
	then
		sudo apt update 
		sudo apt install -y gnupg lsb-release apt-transport-https ca-certificates
		distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)
		wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
		sudo apt update
		pkgs+=" $e"
        else
            pkgs+=" $e"
        fi 
    done
    sudo apt install -y $pkgs
}

# pacman call function
_pacman(){
    local pkgs=""
    for e in $@
    do
        if [ $e = 'build' ]
	then
	    pkgs+=' base-devel'
	elif [ $e = 'node' ]
	then
		pkgs+=' nodejs'
	elif [ $e = 'gfortran' ]
	then
		pkgs+=' gcc-fortran'
	elif [ $e = 'librewolf' ]
	then
		yay -S librewolf-bin
		return
        else
            pkgs+=" $e"
        fi 
    done
    sudo pacman -S --noconfirm --needed $pkgs
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

TMP=$(basedir "$0")/tmp
mkdir "$TMP"

pkginit(){
	if [ $PKG == "pacman" ]
	then
		yay --version
		if [ $? -eq 0 ]
		then
			log i "Yay already installed"
			return
		fi
		log i "Instaling yay..."
		pushd "$TMP"
		git clone https://aur.archlinux.org/yay.git
		if [ $? -ne 0 ]
		then
			log e "Failed to install yay..."
			exit 1
		fi
		cd yay
		makepkg -si
		if [ $? -ne 0 ]
		then
			log e "Failed to install yay..."
			exit 2
		fi
		popd
	fi
}

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

aski(){
    askY "Do you want to install $1 support?"
    if [ $? -eq 1 ]
    then
        pkgi $2 
    fi 
}

