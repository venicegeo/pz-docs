#!/bin/sh

set -e

speller=$1

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)
popd > /dev/null

txts=`find $root/documents -name \*.txt -print`

rm -f badwords

for txt in $txts
do
    #ls $txt
    $speller list --personal=$root/etc/aspell.en_US.per < $txt >> badwords
done

bads=`sort badwords | uniq`

rm -f badwords

if [ "$bads" != "" ]
then
    echo "--------------- misspelled words ---------------"
    echo "$bads"
    echo "--------------- ---------------- ---------------"
    echo ERROR: aborting due to spelling errors
    exit 1
fi

echo Spelling check passed.
exit 0
