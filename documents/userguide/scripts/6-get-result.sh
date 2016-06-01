#!/bin/bash
set -e

# tag::public[]
dataId=$1

curl -X GET -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/data/$dataId" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
# end::public[]

rm -f response.txt status.txt
