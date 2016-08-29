#!/bin/bash

. setup.sh

check_arg $1 dataId

# tag::public[]
dataId=`unquote $1`

$curl -X GET $PZSERVER/file/$dataId?fileName=terrametrics.tif > download.dat
ls -l download.dat
# end::public[]
