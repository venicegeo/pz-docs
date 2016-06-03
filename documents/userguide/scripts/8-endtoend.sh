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

payload='{
    "source": {
        "domain": "s3.amazonaws.com",
        "bucketName": "pz-svcs-prevgen",
        "fileName": "NASA-GDEM-10km-colorized.tif"
    },
    "function": "crop",
    "bounds": {
        "minx": -140.00,
        "miny": 10.00,
        "maxx": -60.00,
        "maxy": 70.00
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

curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$payload" \
    "https://pz-svcs-prevgen.$DOMAIN/crop" > status.txt
# end::public[]

rm -f response.txt status.txt
