#!/bin/bash 

T=$(dirname "$0")

import(){
    source $T/$1.sh 2>> /dev/null 
    if [ $? -ne 0 ]
    then
        source $T/tools/$1.sh 
        if [ $? -ne 0 ]
        then
            echo "IMPORT: tool not found '$1'"
            exit 1
        fi 
    fi 
}

