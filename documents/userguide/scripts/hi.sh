#!/bin/sh

source ./documents/userguide/scripts/vars.sh

# tag::public[] 
set -e

curl -S -s -XGET -o response.txt http://pz-gateway.$domain/health

grep -q OK response.txt
# end::public[] 

rm -f response.txt
