#!/bin/bash -ex

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

for f in $(ls -1 $root/documents) ; do
  base=$(basename $root/$f .txt)
  python $root/scripts/asciidoc-8.6.9/asciidoc.py -o out/$base.html documents/$f
done

tar -czf $APP.$EXT -C $root out
