#!/bin/bash
set -e

#tag::public[]
service="{
    \"url\": \"http://pz-svcs-prevgen.int.geointservices.io/crop\",
    \"method\": \"POST\",
    \"resourceMetadata\": {
        \"name\": \"Preview Generator\",
        \"description\": \"Service that takes payload containing S3 location and bounding box for some raster file, downloads, crops and uploads the crop back up to s3.\"
    }
}"

curl -X POST -S -s \
        -u "$PZKEY":"$PZPASS" \
        -w "%{http_code}" \
        -H 'Content-Type: application/json' \
        -o response.txt \
        -d "$service" \
        "https://pz-gateway.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)
echo "$serviceId"

#end::public[]

rm -f response.txt status.txt
