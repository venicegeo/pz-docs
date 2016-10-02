#!/bin/bash
set -e
. setup.sh

check_arg $1 eventTypeId

# tag::public[]
eventTypeId=$1

event='{
    "eventTypeId": "'"$eventTypeId"'",
    "data": {
        "ItemId": "test",
        "Severity": 200,
        "Problem": "us-bbox"
    }
}'

$curl -X POST -d "$event" $PZSERVER/event
# end::public[]
