#!/bin/bash
set -e
. setup.sh

# tag::public[]
eventtype='{
    "name": "test-'"$(date +%s)"'",
    "mapping": {
        "ItemId": "string",
        "Severity": "integer",
        "Problem": "string"
    }
}'

$curl -X POST -d "$eventtype" $PZSERVER/eventType
# end::public[]
