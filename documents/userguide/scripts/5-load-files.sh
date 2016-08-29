#!/bin/bash

. setup.sh

# tag::public[]
one=$(sh 5-load-file.sh "one" "The quick, brown fox.")
echo "$one"

two=$(sh 5-load-file.sh "two" "The lazy dog.")
echo "$two"

three=$(sh 5-load-file.sh "three" "The hungry hungry hippo.")
echo "$three"
# end::public[]
