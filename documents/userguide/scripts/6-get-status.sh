#!/bin/bash
set -e

[[ -f setup.sh ]] && . setup.sh &> /dev/null

# tag::public[]
jobId=$1

curl -X GET -S -s \
    -u $PZUSER:$PZPASS \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/job/$jobId" > status.txt

grep -q 200 status.txt
# print dataId
grep -E -o '"dataId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
