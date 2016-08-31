#!/bin/bash
set -e
. setup.sh

check_arg $1 triggerId

# tag::public[]
triggerId=$1

$curl -X GET $PZSERVER/alert?triggerId=$triggerId
# end::public[]
