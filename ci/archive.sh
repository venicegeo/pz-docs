#!/bin/bash -e

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

source $root/ci/vars.sh

function doit {
    indir=$1
    outdir=$2
    
    cmd="python $root/scripts/asciidoc-8.6.9/asciidoc.py"
    aaa=`dirname $indir/index.txt`
    bbb=`basename $aaa`
    echo "Proceesing: $bbb/index.txt"
    $cmd -o $outdir/index.html $indir/index.txt > stdout.tmp
    
    # treat asciidoc warnings as errors
    if [ -s stdout.tmp ] ;
    then
      cat stdout.tmp
      exit 1
    fi
    
    echo done
}

rm -f out/*.html out/*/*.html
rm -f stdout.tmp

ins="$root/documents"
outs="$root/out"

#doit $ins $outs
doit $ins/userguide   $outs/userguide
#doit $ins/devguide    $outs/devguide
#doit $ins/devopsguide $outs/devopsguide

echo done

tar -czf $APP.$EXT -C $root out
