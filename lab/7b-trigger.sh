#!/bin/bash
set -e

# run 6a first

eventtypeId=$1
serviceId=$2
[ "$eventtypeId" != "" ] || ( echo error: \$eventtypeId missing ; exit 1 )
[ "$serviceId" != "" ] || ( echo error: \$serviceId missing ; exit 1 )

. setup.sh
url=http://pz-workflow.$DOMAIN

trigger='{
  "title": "High Severity",
    "condition": {
        "eventtype_ids": ["'"$eventtypeId"'"],
        "query": {
            "query": {
                "bool": {
                    "must": [
                        { "match": {"severity": 5} },
                        { "match": {"code": "PHONE"} }
                    ]
                }
            }
        }
    },
    "job": {
        "task": "alert the user",
        "userName": "test",
        "jobType": {
            "type": "execute-service",
            "data": {
                "serviceId": "'"$serviceId"'",
                "dataInputs": {},
                "dataOutput": [ { "mimeType": "application/json", "type": "text" } ]
            }
        }
    }
}'
echo $trigger
$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$trigger" \
    $url/v2/trigger

cat response.txt
echo
