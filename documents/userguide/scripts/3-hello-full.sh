#!/bin/bash

# -e means exit the script if any error
set -e

# ping the gateway, sending the returned string to a file
# "-S -s" means show any errors but don't show the progress meter
ret=`curl -S -s -u "$PZKEY":"" -XGET $PZSERVER`

# verify the response was okay
( echo $ret | grep Hello ) || ( echo ERROR: $ret ; exit 1 )

# provide positive encouragement
echo Success!
