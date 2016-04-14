#!/bin/bash -ex

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

for f in $(ls -1 $root/documents | grep .txt$) ; do
  base=$(basename $root/$f .txt)

  # txt -> html
  python $root/scripts/asciidoc-8.6.9/asciidoc.py -o $root/out/$base.html $root/documents/$f

  # Generate docbook xml for pdf generation
  python $root/scripts/asciidoc-8.6.9/asciidoc.py -a lang=en -v -b docbook -d book $root/documents/$f

  # If dblatex is available, make pdf.
  type dblatex >/dev/null 2>&1 \
      && dblatex -V -T db2latex $root/documents/$base.xml \
      || echo "dblatex not installed: no pdf generated" >&2
done

# Cleanup
rm $root/documents/*.xml

tar -czf $APP.$EXT -C $root out
