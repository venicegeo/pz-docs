#!/bin/bash -ex

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

python scripts/asciidoc-8.6.9/asciidoc.py -o out/piazza.html documents/piazza.txt

tar -czf $APP.$EXT -C $root out
