#!/bin/bash

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

function doit {
    indir=$1
    outdir=$2
    
    cmd="python $root/scripts/asciidoc-8.6.9/asciidoc.py"
    $cmd -o $outdir/index.html $indir/index.txt 2> stderr.tmp
}

rm -f out/*.html out/*/*.html
rm -f stderr.tmp

ins="$root/documents"
outs="$root/out"

doit $ins $outs
doit $ins/userguide $outs/userguide
doit $ins/devguide $outs/devguide
doit $ins/devopsguide $outs/devopsguide

# treat asciidoc warnings as errors
if [ -s stderr.tmp ] ;
then
  cat stderr.tmp
  exit 1
fi

tar -czf $APP.$EXT -C $root out
