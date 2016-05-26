#!/bin/bash
set -e

[[ -f auth.sh ]] && . auth.sh

printenv DOMAIN > /dev/null

# tag::public[]
id=$1

data='{
    "type": "access",
    "dataId": $id,
    "deploymentType": "string"
}'

curl -S -s -X GET \
    -u $USER:$PASS
    -H 'Content-Type: application/json' \
    -d '$data' \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/file/$id?fileName=terrametrics.tif" > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -q jobId response.txt

# print out the jobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
