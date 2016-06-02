#!/bin/sh -ex

printenv DOMAIN > /dev/null

# tag::public[]
data="{
    \"type\": \"ingest\",
    \"host\": true,
    \"data\": {
        \"dataType\": {
            \"type\": \"raster\",
            \"location\": {
                \"type\": \"s3\",
                \"bucketName\": \"bucket-name\",
                \"fileName\": \"elevation.tif\",
                \"domainName\": \"s3.amazonaws.com\"
            }
        },
        \"metadata\": {
            \"name\": \"terrametrics\",
            \"description\": \"geotiff_test\"
        }
    }
}"

curl -S -s -X POST \
    -w "%{http_code}" \
    -o response.txt \
    -H "Content-Type: application/json" \
    -d "$data" \
    "https://pz-gateway.$DOMAIN/data/file" > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -q jobId response.txt

# print out the JobId
grep -o '"jobId":".*"' response.txt | cut -d \" -f 4
# end::public[] 

rm -f response.txt status.txt
