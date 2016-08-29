#!/bin/bash

. setup.sh

check_arg $1 name
check_arg $2 description

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
jobId=`$curl_multipart -X POST \
    -F "data=$data" \
    -F "file=@./terrametrics.tif" \
    $PZSERVER/data/file \
    | jq '.data.jobId'`

jobId=`unquote $jobId`
 
# wait a bit for the load job to finish
sleep 3

# get the data resource id from the job
$curl -X GET $PZSERVER/job/$jobId | jq '.data.result.dataId'
# end::public[]
