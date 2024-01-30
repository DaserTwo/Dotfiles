#!/bin/bash 

T=$(dirname "$0")

_import(){
    places=( $@ )
    for a in "$@"
    do
        source $T/$a.sh 2>> /dev/null
        if [ $? -eq 0 ]
        then
            return 0
        fi
    done
    return 1
}

import(){
   _import $1 tools/$1 ../tools/$1
    if [ $? -ne 0 ]
    then
        echo "IMPORT: tool not found '$1'"
	exit 1
    fi
}

