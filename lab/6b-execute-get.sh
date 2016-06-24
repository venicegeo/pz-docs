#!/bin/bash
set -e

serviceId=$1
[ "$serviceId" != "" ] || ( echo error: \$serviceId missing ; exit 1 )

. setup.sh

job='{
    "type": "execute-service",
    "data": {
        "serviceId": "'"$serviceId"'",
        "dataInputs": { },
        "dataOutput": [ { "mimeType":"application/json", "type":"text" } ]
    }
}'

$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$job" \
    $url/v2/job

cat response.txt
echo
