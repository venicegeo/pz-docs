#!/bin/sh -ex

printenv DOMAIN > /dev/null

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
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" "https://pz-gateway.$DOMAIN/data/file" > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -q jobId response.txt

# print out the jobId
grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4
# end::public[]

rm -f response.txt status.txt
