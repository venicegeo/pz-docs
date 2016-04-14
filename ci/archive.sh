#!/bin/bash -ex

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

for f in $(ls -1 $root/documents | grep .txt$) ; do
  base=$(basename $root/$f .txt)
  python $root/scripts/asciidoc-8.6.9/asciidoc.py -o $root/out/$base.html $root/documents/$f
done

tar -czf $APP.$EXT -C $root out


  #scripts/asciidoc-8.6.9/asciidoc.py -a lang=en -v -b docbook -d book documents/index.txt;dblatex -V -T db2latex documents/index.xml
  #then move that newly created *.pdf file into pz-docs/out folder.
  
#scripts/asciidoc-8.6.9/asciidoc.py -a lang=en -v -b docbook -d book documents/index.txt;dblatex -V -T db2latex documents/index.xml
#scripts/asciidoc-8.6.9/asciidoc.py -a lang=en -v -b docbook -d book documents/index.txt
