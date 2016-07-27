#!/bin/bash
set -e

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

curl -S -s -X POST \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZKEY":"$PZPASS" \
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    "https://pz-gateway.$PZDOMAIN/data/file" > status.txt

# verify 2xx response code
grep -q 20 status.txt || { cat response.txt; exit 1; }
jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# end::public[]

if [ -t 1 ]; then
    echo jobId: "$jobId"
else
    echo "$jobId"
fi

rm -f response.txt status.txt
