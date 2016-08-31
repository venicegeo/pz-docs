#!/bin/bash
set -e
. setup.sh

check_arg $1 name

# tag::public[]
name=$1

data='{
    "type": "ingest", "host": true,
    "data": {
        "dataType": { "type": "raster" },
        "metadata": {
            "name": "'"$name"'",
            "description": "some descriptive text"
        }
    }
}'


# load the file
$curl_multipart -X POST \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    $PZSERVER/data/file \
# end::public[]
