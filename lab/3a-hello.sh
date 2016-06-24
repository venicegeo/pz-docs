#!/bin/bash
set -e

curl -u "$PZUSER":"$PZPASS" -X GET "http://pz-gateway.$DOMAIN/health"
