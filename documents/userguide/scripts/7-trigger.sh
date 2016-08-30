#!/bin/bash
set -e
. setup.sh

check_arg $1 eventTypeId
check_arg $2 serviceId

# tag::public[]
eventTypeId=`unquote $1`
erviceId=`unquote $2`

trigger='{
    "name": "High Severity",
    "condition": {
        "eventTypeIds": ["'"$eventTypeId"'"],
        "query": { "query": { "match_all": {} } }
    },
    "job": {
        "userName": "test",
        "jobType": {
            "type": "execute-service",
            "data": {
                "serviceId": "'"$serviceId"'",
                "dataInputs": {},
                "dataOutput": [ { "mimeType": "application/json", "type": "text" } ]
            }
        }
    },
    "enabled": true
}'

$curl -X POST -d "$trigger" $PZSERVER/trigger | jq .data.triggerId
# end::public[]
