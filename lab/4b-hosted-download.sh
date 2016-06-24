#!/bin/bash
set -e

dataId=$1
[ "$dataId" != "" ] || ( echo error: \$dataId missing ; exit 1 )

. setup.sh

$curl -X GET -o foo.tif $url/file/$dataId

mv response.txt download.tif
ls -l download.tif
