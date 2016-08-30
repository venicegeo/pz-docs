#!/bin/bash
set -e
. setup.sh

# tag::public[]
$curl -X GET $PZSERVER/alert
# end::public[]
