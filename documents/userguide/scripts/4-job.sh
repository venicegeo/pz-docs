#!/bin/bash
set -e

# tag::public[]
jobId=$1

curl -S -s -X GET \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/job/$jobId" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }
grep -E -q '"status"\s?:\s?"Success"' response.txt || { cat response.txt; exit 1; }

# print the data's resource id
grep -E -o '"dataId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
