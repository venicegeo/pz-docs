#!/bin/bash
set -e

# tag::public[]

serviceId=$1

job='{
    "type": "execute-service",
    "data": {
        "serviceId": "'"$serviceId"'",
        "dataInputs": { },
        "dataOutput": [ { "mimeType":"application/json", "type":"text" } ]
    }
}'

curl -X POST -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$job" \
    "https://pz-gateway.$PZDOMAIN/job" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo jobId: "$jobId"
else
    echo "$jobId"
fi

rm -f response.txt status.txt
