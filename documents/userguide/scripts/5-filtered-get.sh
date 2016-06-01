#!/bin/bash
set -e

# tag::public[]
term=$1
id=$2

curl -X GET -S -s \
    -w "%{http_code}" \
    -o response.txt \
    -u $PZUSER:$PZPASS \
    "https://pz-gateway.$DOMAIN/data?keyword=$term&page=0&per_page=100" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
grep -E -o $id response.txt
# end::public[]

rm -f response.txt status.txt
