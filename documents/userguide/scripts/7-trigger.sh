#!/bin/bash
set -e

id=$1
# tag::public[]

# service
service='{
    "url": "http://pzsvc-hello.'$PZDOMAIN'/",
    "contractUrl": "http://helloContract",
    "method": "GET",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example",
        "classType": "unclassified"
    }
}'

echo $service

# POST service
curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-gateway.$PZDOMAIN/service" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

trigger='{
    "title": "High Severity",
    "condition": {
        "eventTypeIds": ["'"$id"'"],
        "query": { "query": { "match_all": {} } }
    },
    "job": {
        "userName": "test",
        "jobType": {
            "type": "execute-service",
            "data": {
                "serviceId": "'"$serviceId"'",
                "dataInputs": {},
                "dataOutput": [ { "mimeType": "application/json", "type": "text" } ]
            }
        }
    },
    "enabled": true
}'

echo $trigger

# POST trigger
curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$trigger" \
    "https://pz-gateway.$PZDOMAIN/trigger" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
triggerId=$(grep -E -o '"triggerId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo triggerId: "$triggerId"
else
    echo "$triggerId"
fi

rm -f response.txt status.txt
