#!/bin/bash
set -e

term=$1
[ "$term" != "" ] || ( echo error: \$term missing ; exit 1 )

. setup.sh

$curl -X GET "$url/data?keyword=$term&page=0&per_page=10"

cat response.txt
echo
