#!/bin/bash
set -e

name=$1
desc=$2
[ "$name" != "" ] || ( echo error: \$name missing ; exit 1 )
[ "$desc" != "" ] || ( echo error: \$description missing ; exit 1 )

. setup.sh

data='{
    "type": "ingest", "host": true,
    "data": { "dataType": { "type": "raster" },
        "metadata": {
            "name": "'"$name"'",
            "description": "'"$desc"'"
        }
    }
}'

# load the file
$curl -X POST \
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    $url/data/file

cat response.txt
echo
