#!/bin/bash
set -e

# tag::public[]

eventtype='{
    "id": "17de4",
    "name": "USDataFound",
    "mapping": {
        "ItemId": "string",
        "Severity": "integer",
        "Problem": "string"
    }
}'

# POST eventtype
echo POSTING EVENTTYPE
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$eventtype" \
    "https://pz-gateway.$DOMAIN/eventType" > status.txt

echo CHECKING EVENTTYPE RESPONSE
grep -q 200 status.txt || { cat response.txt; exit 1; }
id=$(grep -E -o '"id"\s?:\s?".*"' response.txt | cut -d \" -f 4)
echo "$id"
echo POSTED EVENTTYPE
sleep 1


trigger="{
    \"title\": \"High Severity\",
    \"condition\": {
        \"eventtype_ids\": [\"$id\"],
        \"query\": {
            \"query\": {
                \"bool\": {
                    \"must\": [
                        { \"match\": {\"severity\": 5} },
                        { \"match\": {\"code\": \"PHONE\"} }
                    ]
                }
            }
        }
    },
    \"job\": { \"task\": \"alert the user\" }
}"

# POST trigger
echo POSTING TRIGGER
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    -d "$trigger" \
    "https://pz-workflow.$DOMAIN/v2/trigger" > status.txt

echo CHECKING TRIGGER RESPONSE
grep -q 20 status.txt || { cat response.txt; exit 1; }
echo POSTED TRIGGER
sleep 1


event="{
    \"eventtype_id\": \"$id\",
    \"date\": \"2007-06-06T14:30:00Z\",
    \"mapping\": {
        \"datatype\": \"raster\",
        \"espg\": 0,
        \"minX\": 0,
        \"minY\": 0,
        \"maxX\": 0,
        \"maxY\": 0,
        \"hosted\": true
    }
}"

# POST event
echo POSTING EVENT
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$event" \
    "https://pz-gateway.$DOMAIN/event" > status.txt

echo CHECKING EVENT RESPONSE
grep -q 200 status.txt || { cat response.txt; exit 1; }
echo POSTED EVENT
sleep 1


# GET alerts
echo GETTING ALERTS
curl -X GET -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/alert" > status.txt

echo CHECKING ALERTS RESPONSE
grep -q 200 status.txt || { cat response.txt; exit 1; }
cat response.txt
echo GOT ALERTS
sleep 1

# end::public[]

rm -f response.txt status.txt
