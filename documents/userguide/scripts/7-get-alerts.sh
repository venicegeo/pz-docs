#!/bin/bash

. setup.sh

# tag::public[]
$curl -X GET $PZSERVER/alert
# end::public[]
