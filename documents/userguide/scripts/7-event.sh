#!/bin/bash
set -e

id=$1
# tag::public[]

event='{
    "eventtype_id": "'"$id"'",
    "date": "2007-06-08T14:30:00Z",
    "mapping": {
        "ItemId": "test",
        "Severity": 200,
        "Problem": "us-bbox"
    }
}'

# POST event
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$event" \
    "https://pz-gateway.$DOMAIN/event" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }

echo Event posted successfully

# end::public[]

rm -f status.txt response.txt
