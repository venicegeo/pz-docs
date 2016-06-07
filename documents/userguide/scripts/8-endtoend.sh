#!/bin/bash
set -e

# tag::public[]
service="{
    \"url\": \"http://pz-svcs-prevgen.$DOMAIN\",
    \"resourceMetadata\": {
        \"name\": \"Preview Generator\",
        \"description\": \"Service that takes payload containing S3 location and bounding box for some raster file, downloads, crops and uploads the crop back up to s3.\",
        \"method\": \"POST\"
    }
}"

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
    "https://pz-gateway.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
cat response.txt
# print serviceId
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)
echo

job="{
    \"type\": \"execute-service\",
    \"data\": {
        \"serviceId\": \"$serviceId\",
        \"dataInputs\": \"$payload\",
        \"dataOutput\": [ { \"mimeType\":\"application/json\", \"type\":\"text\" } ]
    }
}"


service=

curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$job" \
    "https://pz-gateway.$DOMAIN/v2/job" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
cat response.txt
# end::public[]

rm -f response.txt status.txt
