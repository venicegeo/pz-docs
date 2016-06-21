#!/bin/bash
set -e

# tag::public[]

eventtype='{
    "id": "new id",
    "name": "TESTING",
    "mapping": {
        "ItemId": "string",
        "Severity": "long",
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
echo POSTED EVENTTYPE
sleep 1
echo


# service
service="{
    \"url\": \"http://pzsvc-hello.$DOMAIN/\",
    \"contractUrl\": \"http://helloContract\",
    \"method\": \"GET\",
    \"serviceId\": \"\",
    \"rescurceMetadata\": {
        \"name\": \"pzsvc-hello service\",
        \"description\": \"Hello World Example\"
    }
}"

# post service
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -H 'Content-Type: application/json' \
    -o response.txt \
    -d "$service" \
    "https://pz-gateway.$DOMAIN/service" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
serviceId=$(grep -E -o '"serviceId"\s?:\s?".*"' response.txt | cut -d \" -f 4)


trigger="{
    \"title\": \"High Severity\",
    \"condition\": {
        \"eventtype_ids\": [\"$id\"],
        \"query\": { \"query\": { \"match_all\": {} } }
    },
    \"job\": {
        \"userName\": \"test\",
        \"jobType\": {
            \"type\": \"execute-service\",
            \"data\": {
                \"serviceId\": \"$serviceId\",
                \"dataInputs\": {},
                \"dataOutput\": [ { \"mimeType\": \"application/json\", \"type\": \"text\" } ]
            }
        }
    }
}"

# POST trigger
echo POSTING TRIGGER
curl -X POST -S -s \
    -u "$PZUSER":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    -H 'Content-Type: application/json' \
    -d "$trigger" \
    "https://pz-gateway.$DOMAIN/trigger" > status.txt

echo CHECKING TRIGGER RESPONSE
grep -q 20 status.txt || { cat response.txt; exit 1; }
triggerId=$(grep -E -o '"id"\s?:\s?".*"' response.txt | cut -d \" -f 4)
echo POSTED TRIGGER
sleep 1
echo


event="{
    \"eventtype_id\": \"$id\",
    \"date\": \"2007-06-08T14:30:00Z\",
    \"mapping\": {
        \"ItemId\": \"test\",
        \"Severity\": 200,
        \"Problem\": \"us-bbox\",
        \"jobId\": \"$id\"
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
grep -q 20 status.txt || { cat response.txt; exit 1; }
echo POSTED EVENT
sleep 1
echo


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
echo

# end::public[]

rm -f response.txt status.txt
