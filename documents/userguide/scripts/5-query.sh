#!/bin/bash
set -e

[[ -f setup.sh ]] && . setup.sh &> /dev/null

# tag::public[]
query='{
    "query": {
        "bool": {
            "must": [
                { "match": { "title": "Search" }}
            ]
        }
    }
}
'

curl -X POST -S -s \
    -w "%{http_code}" \
    -o response.txt \
    -u $PZUSER:$PZPASS \
    -H "Content-Type: application/json" \
    -d "$query" \
    "https://pz-gateway.$DOMAIN/data/query" > status.txt

grep -q 200 status.txt
# end::public[]

rm -f response.txt status.txt
