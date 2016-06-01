#!/bin/bash
set -e

# tag::public[]
serviceId=$1

job="{
    \"type\": \"execute-service\",
    \"data\": {
        \"serviceId\": \"$serviceId\",
        \"dataInputs\": { },
        \"dataOutput\": [ { \"mimeType\":\"application/json\", \"type\":\"text\" } ]
    }
}"

curl -X POST -S -s \
    -u $PZUSER:$PZPASS \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$job" \
    "https://pz-gateway.$DOMAIN/v2/job" > status.txt

grep -q 200 status.txt
# print jobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
