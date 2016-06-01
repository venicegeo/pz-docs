#!/bin/bash
# http://stackoverflow.com/questions/307503/whats-the-best-way-to-check-that-environment-variables-are-set-in-unix-shellscr

if [[ $# -eq 0 ]]; then
    # $DOMAIN should always be set
    : ${DOMAIN:?'$DOMAIN is not set'}
    # $PZUSER and $PZPASS can be '' if no authentication needed, so ? -> :?
    : ${PZUSER?'$PZUSER is not set'}
    : ${PZPASS?'$PZPASS is not set'}
    echo 'Environment variables checked'
elif [[ $# -eq 3 ]]; then
    export DOMAIN=$1
    export PZUSER=$2
    export PZPASS=$3
    echo 'Environment Variables set'
    echo 'Ensure that this script was invoked via `. setup.sh DOMAIN PZUSER PZPASS` or'
    echo '`source setup.sh DOMAIN PZUSER PZPASS` or these variables may not be available'
    echo 'in your current shell'
else
    echo 'Please use "source setup.sh DOMAIN PZUSER PZPASS"'
    echo 'Or, "sh setup.sh" to check your environment variables'
    echo 'Number of arguments passed: ' $#
    exit 1
fi
