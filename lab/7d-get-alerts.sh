#!/bin/bash
set -e

#eventId=$1
#[ "$eventId" != "" ] || ( echo error: \$eventId missing ; exit 1 )

. setup.sh
url=http://pz-workflow.$DOMAIN

$curl -X GET "$url/v2/alert"

cat response.txt
