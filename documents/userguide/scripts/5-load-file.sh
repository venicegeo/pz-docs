#!/bin/bash
set -e

# tag::public[]
name=$1
desc=$2

data='{
    "type": "ingest", "host": true,
    "data": {
        "dataType": { "type": "raster" },
        "metadata": {
            "name": "'"$name"'",
            "description": "'"$desc"'"
        }
    }
}'

# load the file
curl -S -s -X POST \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZKEY":"$PZPASS" \
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" "https://pz-gateway.$PZDOMAIN/data/file" > status.txt

grep -q 20 status.txt || { cat response.txt; exit 1; }
grep -q "jobId" response.txt
jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# wait a bit for the load job to finish
sleep 2

# get the data resource id from the job
curl -S -s -X GET \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZKEY":"$PZPASS" \
    "https://pz-gateway.$PZDOMAIN/job/$jobId" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
grep -E -q '"status"\s?:\s?"Success"' response.txt || { cat response.txt; exit 1; }
grep -E -o '"dataId"\s?:\s?".*"' response.txt | cut -d \" -f 4

# end::public[]

rm -f response.txt status.txt
