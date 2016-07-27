#!/bin/bash
set -e

# tag::public[]
id=$1

data="{
    \"type\": \"access\",
    \"dataId\": \"$id\",
    \"deploymentType\": \"geoserver\"
}"

curl -S -s -X POST \
    -u "$PZKEY":"$PZPASS" \
    -H 'Content-Type: application/json' \
    -d "$data" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/deployment" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }

# print out the jobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
