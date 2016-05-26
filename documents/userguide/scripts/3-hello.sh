#!/bin/sh -e

printenv DOMAIN > /dev/null

# tag::public[]
# ping the gateway, sending the returned string to a file
curl -u $USER:$PASS -S -s -X GET -o response.txt "http://pz-gateway.$DOMAIN/health"

# verify the response was "OK"
grep -q OK response.txt
# end::public[] 

rm -f response.txt

echo Pass.
