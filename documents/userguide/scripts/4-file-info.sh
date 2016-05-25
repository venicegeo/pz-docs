#!/bin/sh -ex

printenv DOMAIN > /dev/null

# tag::public[]
id=$1

curl -S -s -X GET \
    -w "%{http_code}" \
    -o response.txt \
    https://pz-gateway.$DOMAIN/data/$id > status.txt

# verify all worked successfully
grep -q 200 status.txt
grep -E -q '"name"\s?:\s?"terrametrics"' response.txt

cat response.txt
# end::public[] 

rm -f response.txt status.txt
