#!/bin/bash 

ask(){
    read -p "$1 [y/n]: " -n 1 -r 
    echo 
    case $REPLY in
        Y|y)
            return 1
            ;;
        N|n)
            return 0 
            ;;
        *)
            echo Invalid option 
            ask "$1"
            return $?
            ;;
    esac 
}

askY(){
    read -p "$1 [Y/n]: " -n 1 -r 
    echo 
    if [ -z $REPLY ]
    then
        return 1 
    fi
    case $REPLY in
        Y|y)
            return 1
            ;;
        N|n)
            return 0 
            ;;
        *)
            echo Invalid option 
            ask "$1"
            return $?
            ;;
    esac 
}

askN(){
    read -p "$1 [y/N]: " -n 1 -r 
    echo 
    if [ -z $REPLY ]
    then
        return 0 
    fi 
    case $REPLY in
        Y|y)
            return 1
            ;;
        N|n)
            return 0 
            ;;
        *)
            echo Invalid option 
            ask "$1"
            return $?
            ;;
    esac 
}

choose(){
    local ps3=$PS3
    PS3=$1
    local ix=0
    shift
    select option in "$@"
    do
        ix=0
	for e in "$@"
	do
            echo "\"$option\"=\"$e\""
	    if [ $option = $e ]
	    then
                PS3=$ps3
                return $ix
	    fi
	    ix=$(($ix+1))
        done
        echo $option is not an option
    done
    PS3=$ps3
    return $ix
}

