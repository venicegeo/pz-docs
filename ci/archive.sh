#!/bin/bash -ex

pushd `dirname $0`/.. > /dev/null
root=$(pwd -P)
popd > /dev/null

type asciidoctor >/dev/null 2>&1 || gem install asciidoctor
type asciidoctor-pdf >/dev/null 2>&1 || gem install --pre asciidoctor-pdf

source $root/ci/vars.sh

function doit {
    indir=$1
    outdir=$2
    
    aaa=`dirname $indir/index.txt`
    bbb=`basename $aaa`
    echo "Proceesing: $bbb/index.txt"
  
    # txt -> html
    asciidoctor -o $outdir/index.html $indir/index.txt  &> errs.tmp
    if [ -s errs.tmp ] ; then
        cat errs.tmp
        exit 1
    fi

    # txt -> pdf
    asciidoctor -r asciidoctor-pdf -b pdf -o $outdir/index.pdf $indir/index.txt  &> errs.tmp
    if [ -s errs.tmp ] ; then
        cat errs.tmp
        exit 1
    fi

    # copy images directory to out dir
    cp -R $indir/images $outdir
    
    # copy scripts directory to out dir
    cp -R $indir/scripts $outdir
}

rm -fr $root/out/*

ins="$root/documents"
outs="$root/out"

doit $ins $outs
doit $ins/userguide   $outs/userguide
doit $ins/devguide    $outs/devguide
doit $ins/devopsguide $outs/devopsguide

# verify the example scripts
echo Checking examples.
$root/documents/userguide/scripts/hi.sh
echo Examples checked.

echo Done.

tar -czf $APP.$EXT -C $root out
