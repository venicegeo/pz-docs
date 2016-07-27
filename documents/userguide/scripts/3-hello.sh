#!/bin/bash
set -e

# tag::public[]
# ping the gateway, sending the returned string to a file
curl -u "$PZKEY":"$PZPASS" -S -s -X GET -o response.txt "http://pz-gateway.$DOMAIN/"

# verify the response was "OK"
grep -q Hello response.txt
# end::public[]

rm -f response.txt

echo Success!
