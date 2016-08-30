#!/bin/bash
set -e
. setup.sh

check_arg $1 eventTypeId

# tag::public[]
eventTypeId=`unquote $1`

event='{
    "eventTypeId": "'"$eventTypeId"'",
    "data": {
        "ItemId": "test",
        "Severity": 200,
        "Problem": "us-bbox"
    }
}'

$curl -d "$event" $PZSERVER/event | jq .data.eventId
# end::public[]
