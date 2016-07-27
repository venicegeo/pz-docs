#!/bin/bash
set -e

# tag::public[]
id=$1

data='{
    "type": "access",
    "dataId": "'"$id"'",
    "deploymentType": "geoserver"
}'

curl -S -s -X POST \
    -u "$PZKEY":"$PZPASS" \
    -H 'Content-Type: application/json' \
    -d "$data" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$PZDOMAIN/deployment" > status.txt

# verify 2xx response code
grep -q 20 status.txt || { cat response.txt; exit 1; }

jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo jobId: "$jobId"
else
    echo "$jobId"
fi

rm -f response.txt status.txt
