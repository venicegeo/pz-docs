#!/bin/sh

source ./documents/userguide/scripts/vars.sh

# tag::public[]
# exit the script if any error 
set -e

# ping the gateway, sending the returned string to a file
# "-S -s" means show any errors but don't show the progress meter
curl -S -s -XGET -o response.txt http://pz-gateway.$domain/health

# verify the response was "OK"
# (because of set -e above, script exits with an error if the match fails)
grep -q OK response.txt
# end::public[] 

rm -f response.txt
