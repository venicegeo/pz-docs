#!/bin/bash
set -e

rm -f response.txt download.tif status.txt

url=https://pz-gateway.$DOMAIN

#status="%{http_code}"

curl="curl -S -s -u $PZUSER:$PZPASS -o response.txt"
