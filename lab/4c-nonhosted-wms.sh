#!/bin/bash
set -e

dataId=$1
[ "$dataId" != "" ] || ( echo error: \$dataId missing ; exit 1 )

. setup.sh

data='{
    "type": "access",
    "dataId": "$id",
    "deploymentType": "geoserver"
}'

$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$data" \
    $url/deployment

cat response.txt
echo
