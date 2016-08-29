#!/bin/bash

source setup.sh

# tag::public[]
data='{
    "type": "ingest",
    "host": true,
    "data": {
        "dataType": {
            "type": "raster"
        },
        "metadata": {
            "name": "terrametrics",
            "description": "geotiff_test"
        }
    }
}'

$curl_multipart -X POST \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    $PZSERVER/data/file \
    | jq '.data.jobId'
# end::public[]
