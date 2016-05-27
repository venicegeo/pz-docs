#!/bin/bash
set -e

[[ -f setup.sh ]] && . setup.sh &> /dev/null

# tag::public[]
one=$(sh 5-load-file.sh "one" "The quick, brown fox.")

two=$(sh 5-load-file.sh "two" "The lazy dog.")

three=$(sh 5-load-file.sh "three" "The hungry hungry hippo.")

echo $one $two $three
# end::public[]
