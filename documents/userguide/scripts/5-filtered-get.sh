#!/bin/sh -e

dir=`dirname $0`
source $dir/setup.sh

# tag::public[]
term=$1
id=$2

$curl -X GET "https://pz-gateway.$DOMAIN/data?keyword=$term&page=0&per_page=100" > status.txt
assert_contains status.txt 200
assert_contains response.txt $id
# end::public[] 

rm -f response.txt status.txt
