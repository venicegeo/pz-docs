#!/bin/bash
# -e means exit the script if any error
set -e

# ping the gateway, sending the returned string to a file
# "-S -s" means show any errors but don't show the progress meter
curl -S -s -X GET -o response.txt -u "$PZUSER":"$PZPASS" "http://pz-gateway.$DOMAIN/health"

# verify the response was "OK"
# (because of set -e above, script exits with an error if the match fails)
grep -q OK response.txt || { cat response.txt; exit 1; }

# remove scratch file
rm -f response.txt

# provide positive encouragement
echo pass.
