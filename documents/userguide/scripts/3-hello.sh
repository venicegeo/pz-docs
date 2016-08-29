#!/bin/bash
set -e

# tag::public[]
# ping the gateway, sending the returned string to a file
ret=`curl -S -s -u "$PZKEY":"" -XGET $PZSERVER`
#echo $ret

# verify the response was good
( echo $ret | grep Hello ) || ( echo ERROR: $ret ; exit 1 )
# end::public[]

echo Success!
