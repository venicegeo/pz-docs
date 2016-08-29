#!/bin/bash

# $PZDOMAIN should always be set to the Piazza server, e.g.
#    export PZSERVER=pz-gateway.int.venicegeo.io
: "${PZSERVER:?"PZSERVER is not set"}"

# $PZKEY should always be set to the API key (a UUID) for the Piazza server
# If ~/.pzkey exists, use that. Otherwise, assume $PZKEY exists.
# See getkey.sh to generate a key for yourself.
if [ -f ~/.pzkey ] ; then
    export PZKEY=`cat ~/.pzkey | grep $PZSERVER | cut -f 2 -d ":" | cut -d \" -f 2`
else
    : "${PZKEY?"PZKEY is not set"}"
fi

#echo Environment: $PZDOMAIN $PZKEY

# add common options to curl command
curl="curl -S -s -u $PZKEY:"" -H Content-Type:application/json"
curl_multipart="curl -S -s -u $PZKEY:"" -H Content-Type:multipart/form-data;boundary=thisismyboundary"


# function to verify a command-line argument is present
#
# Assume a script foo.sh was invoked like this:
#     $ sh foo.sh 123 456
# then the bash comand
#    check_arg $2 "id2"
# will verify that the second argument on the command line ("456") was present,
# otherwise the script will exit with a usage error.
check_arg() {
    arg=$1
    name=$2
    if [ "$#" -ne "2" ];
    then
        echo "Internal error: check_arg has bad args: $@"
        exit 1
    fi
    if [ "$arg" == "" ]
    then
        echo "usage error: \$name missing"
        exit 1
    fi
}

# This will removes quotes from a string, e.g. "asdf" it will return asdf.
unquote() {
    echo $1 | tr -d '"'
}
