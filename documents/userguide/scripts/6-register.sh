#!/bin/bash

. setup.sh

# tag::public[]
hello=`echo $PZSERVER | sed -e sXpz-gatewayXhttp://pzsvc-helloX`

service='{
    "url": "'"$hello"'",
    "contractUrl": "http://helloContract",
    "method": "GET",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example",
        "classType": "unclassified"
    }
}'

$curl -X POST -d "$service" $PZSERVER/service | jq '.data.serviceId'
# end::public[]
