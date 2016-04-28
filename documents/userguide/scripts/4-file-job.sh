#!/bin/sh -ex

printenv DOMAIN > /dev/null

# tag::public[]
id=$1

curl -S -s -X GET \
    -w "%{http_code}" \
    -o response.txt \
    https://pz-gateway.$DOMAIN/job/$id > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -q '"status":"Success"' response.txt

# print the data's resource id
grep -o '"dataId":".*"' response.txt | cut -d \" -f 4

cat response.txt
# end::public[] 

rm -f response.txt status.txt
