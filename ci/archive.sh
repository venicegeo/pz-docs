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

    # txt -> html
    $cmd -o $outdir/index.html $indir/index.txt > stdout.tmp
    
    # treat asciidoc warnings as errors
    if [ -s stdout.tmp ] ;
    then
      cat stdout.tmp
      exit 1
    fi
    
    # Generate docbook xml for pdf generation
    $cmd -a lang=en -v -b docbook -d book -o $outdir/index.xml $indir/index.txt
    
    # If dblatex is available, make pdf.
    type dblatex >/dev/null 2>&1 \
        && dblatex -V -T db2latex $outdir/index.xml \
        || echo "dblatex not installed: no pdf generated" >&2

    echo done
}

rm -f $root/out/*.html $root/out/*/*.html
rm -f $root/stdout.tmp

ins="$root/documents"
outs="$root/out"

doit $ins $outs
doit $ins/userguide   $outs/userguide
doit $ins/devguide    $outs/devguide
doit $ins/devopsguide $outs/devopsguide

echo done

# Cleanup
rm -f $root/out/index.xml $root/out/*/index.xml

tar -czf $APP.$EXT -C $root out
