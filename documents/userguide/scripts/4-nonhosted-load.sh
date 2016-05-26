#!/bin/bash
set -e

[[ -f auth.sh ]] && . auth.sh

printenv DOMAIN > /dev/null

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
            "name": "My Test raster external file",
            "description": "This is a test.",
            "classType": "unclassified"
        }
    }
}'

curl -S -s -X POST \
    -w "%{http_code}" \
    -u $USER:$PASS \
    -o response.txt \
    -H "Content-Type: application/json" \
    -d "$data" \
    "https://pz-gateway.$DOMAIN/data" > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -q jobId response.txt

# print out the jobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
