#!/bin/bash

ANS_HOST=localhost
ANS_USER=root
ANS_PASS=root
ANS_NAME=

function display_help () {
    cat template_tests/help.txt
}

function parse_cli () {
    COMMAND="$1"
    if [ -z $COMMAND ]
    then
        echo "ERROR : Missing command"
        display_help
        exit 1
    fi
}

function generate() {
    if [ -z "$ANS_NAME" ]
    then
        echo "ERROR : Missing parameter --name"
        display_help
        exit 3
    fi
    echo "Generating environnement with : "
    echo "Name : $ANS_NAME"
    echo "Host : $ANS_HOST"
    echo "User : $ANS_USER"
    echo "Password : $ANS_PASS"
    
    mkdir $ANS_NAME
    
    cp template_tests/template_main.yml $ANS_NAME/main.yml || exit 1
    cp template_tests/template_launch.sh $ANS_NAME/launch.sh || exit 1
    cp template_tests/template_hosts $ANS_NAME/hosts || exit 1
    
    sed -i -e "s/{{host}}/$ANS_HOST/g" $ANS_NAME/hosts || exit 1
    sed -i -e "s/{{user}}/$ANS_USER/g" $ANS_NAME/hosts || exit 1
    sed -i -e "s/{{pass}}/$ANS_PASS/g" $ANS_NAME/hosts || exit 1
    
    echo "SUCCESS : $ANS_NAME generated"
}

function parse_parameters() {
    while [[ $# -gt 1 ]]
    do
    key="$1"

    case $key in
        -u|--user)
        ANS_USER="$2"
        shift # past argument
        ;;
        -p|--password)
        ANS_PASS="$2"
        shift # past argument
        ;;
        -h|--host)
        ANS_HOST="$2"
        shift # past argument
        ;;
        -n|--name)
        ANS_NAME="$2"
        ;;
        *)
        ;;
    esac
    shift # past argument or value
    done
}


parse_cli $1
shift

case $COMMAND in
help)
    display_help
    ;;
gen)
    parse_parameters $@
    generate
    ;;
*)
    echo "ERROR : Unrecognized command $COMMAND"
    display_help
    exit 2
    ;;
esac
