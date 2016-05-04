#!/bin/sh -e
# -e means exit the script if any error 

# verify $DOMAIN set; will error if not
printenv DOMAIN > /dev/null

# ping the gateway, sending the returned string to a file
# "-S -s" means show any errors but don't show the progress meter
curl -S -s -XGET -o response.txt http://pz-gateway.$DOMAIN/health

# verify the response was "OK"
# (because of set -e above, script exits with an error if the match fails)
grep -q OK response.txt

# remove scratch file
rm -f response.txt

# provide positive encouragement
echo Pass.