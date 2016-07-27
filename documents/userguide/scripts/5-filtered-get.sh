#!/bin/bash
set -e

# tag::public[]
term=$1

curl -X GET -S -s \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZKEY":"$PZPASS" \
    "https://pz-gateway.$PZDOMAIN/data?keyword=$term" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
cat response.txt
# end::public[]

rm -f response.txt status.txt
