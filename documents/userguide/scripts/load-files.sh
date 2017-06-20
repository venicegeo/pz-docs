#!/bin/bash
set -e
. setup.sh

# tag::public[]
a="one"
b="The quick, brown fox."
one=`./post-hosted-load.sh "$a" "$b"`
echo "$one"

a="two"
b="The lazy dog."
two=`./post-hosted-load.sh "$a" "$b"`
echo "$two"

a="three"
b="The hungry hungry hippo."
three=`./post-hosted-load.sh "$a" "$b"`
echo "$three"
# end::public[]
