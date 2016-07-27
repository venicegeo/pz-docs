#!/bin/bash
set -e

# tag::public[]
jobId=$1

curl -X GET -S -s \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$PZDOMAIN/job/$jobId" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }
grep -E -q '"status"\s?:\s?"Success"' response.txt || { cat response.txt; exit 1; }

dataId=$(grep -E -o '"dataId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo dataId: "$dataId"
else
    echo "$dataId"
fi

rm -f response.txt status.txt
