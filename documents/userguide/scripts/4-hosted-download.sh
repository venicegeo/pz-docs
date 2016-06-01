#!/bin/bash
set -e

# tag::public[]
id=$1

curl -S -s -X GET \
    -u $PZUSER:$PZPASS \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$DOMAIN/file/$id?fileName=terrametrics.tif" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }
# end::public[]

echo pass.

rm -f response.txt status.txt
