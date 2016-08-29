#!/bin/bash

. setup.sh

# tag::public[]
data='{
    "type": "ingest",
    "host": false,
    "data": {
        "dataType": {
            "type": "raster",
            "location": {
                "type": "s3",
                "bucketName": "external-public-access-test",
                "fileName": "elevation.tif",
                "domainName": "s3.amazonaws.com"
            }
        },
        "metadata": {
            "name": "elevation",
            "description": "geotiff_test"
        }
    }
}'

$curl -XPOST -d "$data" $PZSERVER/data | jq '.data.jobId'
# end::public[]
