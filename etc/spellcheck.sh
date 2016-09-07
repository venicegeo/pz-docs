#!/bin/sh

set -e

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)
popd > /dev/null

txts=`find $root/documents -name \*.txt -print`

rm -f badwords

for txt in $txts
do
    #ls $txt
    aspell list --personal=$root/etc/aspell.en_US.per < $txt >> badwords
done

bads=`sort badwords | uniq`

rm -f badwords

if [ "$bads" != "" ]
then
    echo "$bads"
    exit 1
fi

exit 0
