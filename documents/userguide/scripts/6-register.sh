#!/bin/bash
set -e

# tag::public[]
service="{
    \"url\": \"http://pzsvc-hello.$DOMAIN/\",
    \"method\": \"GET\",
    \"resourceMetadata\": {
        \"name\": \"pzsvc-hello service\",
        \"description\": \"Hello World Example\"
    }
}"

curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-gateway.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
# print serviceId
grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
