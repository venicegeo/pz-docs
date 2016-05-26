#!/bin/bash
set -e

[[ -f auth.sh ]] && . auth.sh

# tag::public[]
query='
{
  "query": {
    "bool": {
      "must": [
        { "match": { "title": "Search"          }},
        { "match": { "content": "Elasticsearch" }}
        ]
    }
  }
}
'

curl -X POST -S -s \
    -w "%{http_code}" \
    -o response.txt \
    -u $USER:$PASS \
    -H "Content-Type: application/json" \
    -d "$query" \
    "https://pz-gateway.$DOMAIN/data/query" > status.txt

grep -q 200 status.txt
# end::public[]

rm -f response.txt status.txt
