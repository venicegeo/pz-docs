#!/bin/bash
set -e

# tag::public[]
term=$1

query="{
    \"query\": {
        \"match\": { \"_all\": \"$term\" }
    }
}"

curl -X POST -S -s \
    -w "%{http_code}" \
    -o response.txt \
    -u "$PZUSER":"$PZPASS" \
    -H "Content-Type: application/json" \
    -d "$query" \
    "https://pz-gateway.$DOMAIN/data/query" > status.txt

grep -q 200 status.txt || { cat response.txt; exit 1; }
# end::public[]
cat response.txt

echo pass.

rm -f response.txt status.txt
