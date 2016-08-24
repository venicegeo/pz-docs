#!/bin/bash
set -e

source init.sh

fileId=`get_arg $1 fileId`

# tag::public[]
curl -S -s -X GET \
    -u "$PZKEY":"$PZPASS" \
    -w "%{http_code}" \
    -o response.txt \
    "https://pz-gateway.$PZDOMAIN/file/$fileId?fileName=terrametrics.tif" > status.txt

# verify all worked successfully
grep -q 200 status.txt || { cat response.txt; exit 1; }

# end::public[]

echo Success!

rm -f response.txt status.txt
