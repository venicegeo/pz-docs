#!/bin/bash

. setup.sh

# tag::public[]
a="one"
b="The quick, brown fox."
one=`sh 5-load-file.sh $a $b`
echo "$one"

a="two"
b="The lazy dog."
two=`sh 5-load-file.sh $a $b`
echo "$two"

a="three"
b="The hungry hungry hippo."
three=`sh 5-load-file.sh $a $b`
echo "$three"
# end::public[]
