#!/bin/sh

set -e

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)
popd > /dev/null

hostname=$1

htmls=`find $root/out -name \*.html -print`
pdfs=`find $root/out -name \*.pdf -print`
for file in $htmls $pdfs
do
    echo $file

    # We have to use ed instead of sed because the PDFs have non-ASCII chars in them. 
    ### sed -i ".bak" "s/venicegeo\.io/$hostname/g" $file
    
    ed -s $file <<!
,s/venicegeo\.io/$hostname/g
w
q
!
done
