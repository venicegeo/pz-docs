#!/bin/bash
set -e

. setup.sh

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

$curl -X POST \
    -H "Content-Type: multipart/form-data; boundary=__quickbrownfox__" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    $url/data/file

cat response.txt
echo
