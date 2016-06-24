#!/bin/bash
set -e

jobId=$1
[ "$jobId" != "" ] || ( echo error: \$jobId missing ; exit 1 )

. setup.sh

$curl -X GET $url/job/$jobId

cat response.txt
echo
