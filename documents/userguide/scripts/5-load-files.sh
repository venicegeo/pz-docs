#!/bin/sh -e

dir=`dirname $0`
source $dir/setup.sh

# tag::public[]
one=`$dir/5-load-file.sh "one" "The quick, brown fox."`

two=`$dir/5-load-file.sh "two" "The lazy dog."`

echo $one $two
# end::public[] 
