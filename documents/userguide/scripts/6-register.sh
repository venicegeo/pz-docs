#!/bin/bash
set -e

# tag::public[]

service='{
    "url": "http://pzsvc-hello.'"$PZDOMAIN"'/",
    "contractUrl": "http://helloContract",
    "serviceId": "",
    "method": "GET",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example",
        "classType": "unclassified"
    }
}'

curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-gateway.$PZDOMAIN/service" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo serviceId: "$serviceId"
else
    echo "$serviceId"
fi

rm -f response.txt status.txt
