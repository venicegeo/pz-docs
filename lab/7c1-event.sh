#!/bin/bash
set -e

eventtypeId=$1
[ "$eventtypeId" != "" ] || ( echo error: \$eventtypeId missing ; exit 1 )

. setup.sh
url=http://pz-workflow.$DOMAIN

now=`date "+%Y-%m-%dT%H:%M:%SZ"`

event='{
    "eventtype_id": "'"$eventtypeId"'",
    "date": "'"$now"'",
    "data": {
        "filename": "dataset-a",
        "severity": 5,
        "code": "BBOX"
    }
}'
echo $event
$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$event" \
    $url/v2/event

cat response.txt
echo
