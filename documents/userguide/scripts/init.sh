#!/bin/bash


curl="curl -S -s -o tmp -w "%{http_code}" -u $PZKEY:"" -H Content-Type:application/json"


url="http://pz-gateway.$PZDOMAIN"

extract() {
    item=$1
    str=$2

    echo "$str" | grep $item | cut -f 2 -d ":" | cut -d \" -f 2
}

get_arg() {
    arg=$1
    name=$2

    if [ "$arg" == "" ]
    then
        echo "usage error: \$name missing"
        exit 1
    fi
}
