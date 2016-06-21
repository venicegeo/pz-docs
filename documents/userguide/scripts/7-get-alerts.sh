#!/bin/bash
set -e

# tag::public[]

# GET alerts
curl -X GET -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/alert" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }

cat response.txt

# end::public[]

rm -f response.txt status.txt
