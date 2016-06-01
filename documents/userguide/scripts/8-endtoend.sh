#!/bin/bash
set -e

# tag::public[]
service='{
    "url": "http://pzsvc-hello.venicegeo.io/",
    "contractUrl": "http://helloContract",
    "serviceId": "",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example",
        "method": "GET"
    }
}'

curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-svcs-prevgen.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
# print serviceId
grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
