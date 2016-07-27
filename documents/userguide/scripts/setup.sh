#!/bin/bash

if [[ $# -eq 3 ]]; then
    PZDOMAIN=$1
    PZUSER=$2
    PZPASS=$3
    # overwrite old .pzenv files...
    echo "PZDOMAIN='$PZDOMAIN'" > .pzenv
    echo "PZPASS='$PZPASS'" >> .pzenv

    resp=$(curl -XGET -u "$PZUSER":"$PZPASS" "https://pz-gateway.$PZDOMAIN/key" -S -s)

    PZKEY=$(echo "$resp" | grep -E -o '"uuid"\s?:\s?".*"' | cut -d \" -f 4)

    echo "PZKEY='$PZKEY'" >> .pzenv

    echo 'Created .pzenv file in your pwd!'
else
    echo 'Usage:'
    echo '    ./setup.sh "PZDOMAIN" "PZUSER" "PZPASS"'
    echo 'Number of arguments passed: ' $#
        # $DOMAIN should always be set
    : "${DOMAIN:?"DOMAIN is not set"}"
    # $PZUSER and $PZPASS can be '' if no authentication needed, so ? -> :?
    : "${PZUSER?"PZUSER is not set"}"
    : "${PZPASS?"PZPASS is not set"}"
    echo '  Environment variables set'
fi
