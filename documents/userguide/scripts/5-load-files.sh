#!/bin/bash
set -e

# tag::public[]
one=$(sh 5-load-file.sh "one" "The quick, brown fox.")

two=$(sh 5-load-file.sh "two" "The lazy dog.")

three=$(sh 5-load-file.sh "three" "The hungry hungry hippo.")

echo "$one" "$two" "$three"
# end::public[]
