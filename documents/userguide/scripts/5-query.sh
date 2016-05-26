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
    -u $USER:$PASS
    -H "Content-Type: application/json" \
    -H "Accept: text/plain" \
    -d "$query" \
    "https://pz-gateway.$DOMAIN/data/query" > status.txt

assert_contains status.txt 200
# FIXME: what is this supposed to do?
assert_contains response.txt $id
# end::public[]

rm -f response.txt status.txt
