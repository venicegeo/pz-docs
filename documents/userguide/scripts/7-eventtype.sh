#!/bin/bash
set -e

# tag::public[]

eventtype='{
    "name": "test-'"$(date +%s)"'",
    "mapping": {
        "ItemId": "string",
        "Severity": "integer",
        "Problem": "string"
    }
}'

# POST eventtype
curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$eventtype" \
    "https://pz-gateway.$DOMAIN/eventType" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
eventTypeId=$(grep -E -o '"eventTypeId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]
#
if [ -t 1 ]; then
    echo eventTypeId: "$eventTypeId"
else
    echo "$eventTypeId"
fi

rm -f status.txt response.txt
