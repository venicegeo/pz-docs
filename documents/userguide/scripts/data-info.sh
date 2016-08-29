#!/bin/bash

. setup.sh

check_arg $1 jobId

# tag::public[]
dataId=`unquote $1`

$curl -X GET $PZSERVER/data/$dataId
# end::public[]
