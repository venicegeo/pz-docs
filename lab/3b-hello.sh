#!/bin/bash
set -e

. setup.sh

$curl -X GET $url/health

cat response.txt
echo
