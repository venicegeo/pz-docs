#!/bin/bash
set -e

id=$1
# tag::public[]

# service
service='{
    "url": "http://pzsvc-hello.'$DOMAIN'/",
    "contractUrl": "http://helloContract",
    "method": "GET",
    "serviceId": "",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example"
    }
}'

# POST service
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-gateway.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)


trigger='{
    "title": "High Severity",
    "condition": {
        "eventtype_ids": ["'"$id"'"],
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
    }
}'

# POST trigger
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$trigger" \
    "https://pz-gateway.$DOMAIN/trigger" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
triggerId=$(grep -E -o '"id"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo Trigger ID: "$triggerId"
else
    echo "$triggerId"
fi

rm -f response.txt status.txt
