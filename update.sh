#!/bin/bash

if [[ -d ~/.dotfiles ]]
then
	cd ~/.dotfiles
	git pull
else
	git clone https://github.com/DaserTwo/dotfiles.git ~/.dotfiles
	cd ~/.dotfiles
fi



