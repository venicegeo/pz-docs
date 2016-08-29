#!/bin/bash

. setup.sh

check_arg $1 dataId

# tag::public[]
dataId=`unquote $1`

data='{
    "type": "access",
    "dataId": "'"$dataId"'",
    "deploymentType": "geoserver"
}'

$curl -X POST -d "$data" $PZSERVER/deployment
# end::public[]
