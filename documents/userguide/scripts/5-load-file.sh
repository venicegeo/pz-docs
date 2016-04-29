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
$curl -X POST \
    -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" \
    -F "data=$data" \
    -F "file=@$dir/terrametrics.tif" \
    https://pz-gateway.$DOMAIN/data/file > status.txt
assert_contains status.txt 200
assert_contains response.txt jobId
id=`extract_jobid response.txt`

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
