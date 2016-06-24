#!/bin/bash
set -e

. setup.sh

service='{
    "url": "'"http://pzsvc-hello.$DOMAIN/"'",
    "contractUrl": "http://helloContract",
    "serviceId": "",
    "method": "GET",
    "resourceMetadata": {
        "name": "pzsvc-hello service",
        "description": "Hello World Example"
    }
}'

$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$service" \
    $url/service

cat response.txt
echo
