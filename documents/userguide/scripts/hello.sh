#!/bin/bash

set -e

. setup.sh

$curl -X GET $PZSERVER
