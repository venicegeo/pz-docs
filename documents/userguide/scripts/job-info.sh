#!/bin/bash

. setup.sh

check_arg $1 jobId

# tag::public[]
jobId=`unquote $1`

$curl -XGET $PZSERVER/job/$jobId
# end::public[]
