#!/bin/bash

. setup.sh

check_arg $1 term

# tag::public[]
term=$1

query='{
    "query": {
        "match": { "_all": "'"$term"'" }
    }
}'

$curl -X POST -d "$query" $PZSERVER/data/query
# end::public[]
