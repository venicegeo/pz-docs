#!/bin/bash
set -e

id=$1
# tag::public[]

event='{
    "eventTypeId": "'"$id"'",
    "data": {
        "ItemId": "test",
        "Severity": 200,
        "Problem": "us-bbox"
    }
}'

# POST event
curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$event" \
    "https://pz-gateway.$DOMAIN/event" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
eventId=$(grep -E -o '"eventId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo eventId: "$eventId"
else
    echo "$eventId"
fi

rm -f status.txt response.txt
