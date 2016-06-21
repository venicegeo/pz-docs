#!/bin/bash
set -e

# tag::public[]

eventtype='{
    "id": "different",
    "name": "adfasf",
    "mapping": {
        "ItemId": "string",
        "Severity": "long",
        "Problem": "string"
    }
}'

# POST eventtype
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$eventtype" \
    "https://pz-gateway.$DOMAIN/eventType" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
id=$(grep -E -o '"id"\s?:\s?".*"' response.txt | cut -d \" -f 4)

echo "$id"

# end::public[]

rm -f status.txt response.txt
