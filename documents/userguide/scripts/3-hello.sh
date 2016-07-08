#!/bin/bash
set -e

# tag::public[]
# ping the gateway, sending the returned string to a file
curl -u "$PZUSER":"$PZPASS" -S -s -X GET -o response.txt "http://pz-gateway.$DOMAIN/"

# verify the response was "OK"
grep -q OK response.txt
# end::public[]

rm -f response.txt

echo pass.
