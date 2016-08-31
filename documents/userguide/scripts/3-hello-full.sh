#!/bin/bash

# -e means exit the script if any error
set -e

# ping Piazza, saving the response string
# "-S -s" means show any errors but don't show the progress meter
# "-u" supplies the user credentials
curl -S -s -u "$PZKEY":"" -XGET $PZSERVER
