#!/bin/bash
set -e

# tag::public[]
id=$1

curl -S -s -X GET \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZUSER":"$PZPASS" \
    "https://pz-gateway.$DOMAIN/data/$id" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }
cat response.txt
# end::public[]

rm -f response.txt status.txt
