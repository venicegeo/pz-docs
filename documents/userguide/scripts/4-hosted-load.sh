#!/bin/bash
set -e
source setup.sh

check_arg $1 name

# tag::public[]
name=$1

data='{
    "type": "ingest",
    "host": true,
    "data": {
        "dataType": {
            "type": "raster"
        },
        "metadata": {
            "name": "'"$name"'",
            "description": "mydescription"
        }
    }
}'

# "curl_multipart" sets ContentType for a multipart POST body
$curl_multipart -X POST \
    -F "data=$data" -F "file=@./terrametrics.tif" \
    $PZSERVER/data/file
# end::public[]
