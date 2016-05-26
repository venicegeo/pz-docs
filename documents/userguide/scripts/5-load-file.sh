#!/bin/sh -e

dir=`dirname $0`
source $dir/setup.sh

# tag::public[]
name=$1
desc=$2

data="{
    \"type\": \"ingest\", \"host\": true,
    \"data\": { \"dataType\": { \"type\": \"raster\" },
        \"metadata\": {
            \"name\": \"$name\",
            \"description\": \"$desc\"
        }
    }
}"

# load the file
curl -S -s -X POST \
    -w "%{http_code}" \
    -o response.txt \
    -u $USER:$PASS \
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" https://pz-gateway.$DOMAIN/data/file > status.txt

grep -q "200" status.txt
grep -q "jobId" response.txt
jobId=$(grep -E -o '"jobId"\s?:\s?".*"' response.txt | cut -d \" -f 4)

# wait a bit for the load job to finish
sleep 3

# get the data resource id from the job
$curl -S -s -X GET https://pz-gateway.$DOMAIN/job/$id > status.txt
assert_contains status.txt 200
assert_contains response.txt '"status":"Success"'
assert_contains response.txt dataId
id=`extract_dataid response.txt`

# print our result
echo $id
# end::public[] 

rm -f response.txt status.txt
