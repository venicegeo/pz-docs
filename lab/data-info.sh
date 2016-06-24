#!/bin/bash
set -e

dataId=$1
[ "$dataId" != "" ] || ( echo error: \$dataId missing ; exit 1 )

. setup.sh

$curl -X GET $url/data/$dataId

cat response.txt
echo
