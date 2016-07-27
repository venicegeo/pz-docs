#!/bin/bash
set -e

# tag::public[]
data='{
    "type": "ingest",
    "host": false,
    "data": {
        "dataType": {
            "type": "raster",
            "location": {
                "type": "s3",
                "bucketName": "external-public-access-test",
                "fileName": "elevation.tif",
                "domainName": "s3.amazonaws.com"
            }
        },
        "metadata": {
            "name": "elevation",
            "description": "geotiff_test"
        }
    }
}'

curl -S -s -X POST \
    -w "%{http_code}" \
    -o response.txt \
    -H "Content-Type: application/json" \
    -d "$data" \
    -u "$PZKEY":"$PZPASS" \
    "https://pz-gateway.$DOMAIN/data" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }
grep -q jobId response.txt

# print out the JobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
