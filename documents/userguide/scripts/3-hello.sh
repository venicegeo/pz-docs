#!/bin/bash

# tag::public[]
set -e
. setup.sh

$curl -XGET $PZSERVER
# end::public[]
