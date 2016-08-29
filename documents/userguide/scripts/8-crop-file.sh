#!/bin/bash

. setup.sh

check_arg $1 serviceId
check_arg $2 bucket
check_arg $3 file

#tag::public[]
serviceId=$1
bucket=$2
file=$3

job='{
    "type": "execute-service",
    "data": {
        "serviceId": "'"$serviceId"'",
        "dataInputs": {
            "test": {
                "content": "{ \"source\": { \"domain\": \"s3.amazonaws.com\", \"bucketName\": \"'"$bucket"'\", \"fileName\": \"'"$file"'\" }, \"function\": \"crop\", \"bounds\": { \"minx\": -140.00, \"miny\": 10.00, \"maxx\": -60.00, \"maxy\": 70.00 } }",
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

$curl -X POST -d "$job" $PZSERVER/job | jq .data.jobId
#end::public[]
