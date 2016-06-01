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

trigger="{
    \"id\": \"987d6\",
    \"title\": \"my found-a-bad-telephone-number trigger\",
    \"condition\": {
        \"eventtype_ids\": [\"17de4\"], # array of event type ids
        \"query\" : { # the Elasticsearch query string
            \"bool\": {
                \"must\": [
                    { \"match\" : { \"Severity\" : 4 } },
                    { \"match\" : { \"Problem\" : \"us-bbox\" } }
                ]
            }
        },
        \"job\": {
            \"Task\": {\"userName\": \"$PZUSER\", \"jobType\": {\"type\": \"get\", \"jobId\": \"test\"}}
        }
    }
}"

event="{
    \"id\": \"53dac\"
    \"eventtype_id\": \"17de4\",
    \"date\": \"2007-04-05T14:30:00Z\",
    \"data\": {
        \"ItemId\": \"eb872\",  # in this case, the id of a data item loaded into Pz
        \"Severity\": 4,
        \"Problem\": \"us-bbox\",
        \"userName\": \"my-api-key-38n987\",
        \"jobId\": \"43688858-b6d4-4ef9-a98b-163e1980bba8\"
    }
}"

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
echo POSTED EVENTTYPE
sleep 1

# POST trigger
echo POSTING TRIGGER
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$trigger" \
    "https://pz-gateway.$DOMAIN/trigger" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
echo POSTED TRIGGER
sleep 1

# POST event
echo POSTING EVENT
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$event" \
    "https://pz-gateway.$DOMAIN/event/USDataFound" > status.txt

echo CHECKING EVENT RESPONSE
grep -q 200 status.txt || { cat response.txt; exit 1; }
echo POSTED EVENT

# GET alerts
echo GETTING ALERTS
curl -X GET -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/alert" > status.txt

echo CHECKING ALERTS RESPONSE
grep -q 200 status.txt || { cat response.txt; exit 1; }
echo GOT ALERTS
sleep 1

# end::public[]

rm -f response.txt status.txt
