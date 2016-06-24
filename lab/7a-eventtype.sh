#!/bin/bash
set -e

. setup.sh
url=http://pz-workflow.$DOMAIN

eventtype='{
  "name": "USDataEventX",
   "mapping": {
       "filename": "string",
       "code":     "string",
       "severity": "integer"
   }
}'

$curl -X POST \
    -H 'Content-Type: application/json' \
    -d "$eventtype" \
    $url/v2/eventType

cat response.txt
echo
