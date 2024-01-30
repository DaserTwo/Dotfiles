#!/bin/bash

. $(dirname "$0")/tools/import.sh
import log

conf(){
	if [[ -f ~/$2 ]]
	then
		log w "Detected old config ~/$2"
		mv ~/$2 ~/$2.old
	fi
	
	p=$(dirname "$0")/files/"$1"
	cp "$p" ~/$2
}

dotconf(){
	if [[ -d ~/.config/$1 ]]
	then
		log w "Detected old config ~/.config/$1"
		mv ~/.config/$1 ~/.config/$1.old
	fi

	mkdir ~/.config/$1
	p=$(dirname "$0")/files/"$2"
	cp "$p" ~/.config/$1/$3
}

