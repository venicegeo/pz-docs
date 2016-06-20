#!/bin/bash
set -e

serviceId=$1

#tag::public[]

job='{
    "type": "execute-service",
    "data": {
        "serviceId": "'"$serviceId"'",
        "dataInputs": {
            "test": {
                "content": "{ \"source\": { \"domain\": \"s3.amazonaws.com\", \"bucketName\": \"pz-svcs-prevgen\", \"fileName\": \"NASA-GDEM-10km-colorized.tif\" }, \"function\": \"crop\", \"bounds\": { \"minx\": -140.00, \"miny\": 10.00, \"maxx\": -60.00, \"maxy\": 70.00 } }",
                "type": "body",
                "mimeType": "application/json"
                }
            },
        "dataOutput": [ {
            "mimeType":"image/tiff",
            "type":"raster"
        } ]
    }
}'

curl -X POST -S -s \
        -u "$PZUSER":"$PZPASS" \
        -w "%{http_code}" \
        -H 'Content-Type: application/json' \
        -o response.txt \
        -d "$job" \
        "https://pz-gateway.$DOMAIN/v2/job" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)
echo JobID: "$jobId"

#end::public[]

rm -f response.txt status.txt
