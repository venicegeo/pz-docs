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


function run_tests {
    # verify the example scripts
    echo Checking examples.

    echo "Checking section 3 examples"
    #$root/documents/userguide/scripts/3-hello.sh
    #$root/documents/userguide/scripts/3-hello-full.sh

    echo "Checking section 4 examples"
    #jobid=`$root/documents/userguide/scripts/4-file-load.sh`
    #dataid=`$root/documents/userguide/scripts/4-file-job.sh $jobid`
    #$root/documents/userguide/scripts/4-file-info.sh $dataid
    #$root/documents/userguide/scripts/4-file-download.sh $dataid
    #$root/documents/userguide/scripts/4-file-wms.sh $dataid

    echo "Checking section 5 examples"

    echo "Checking section 6 examples"

    echo "Checking section 7 examples"

    echo Examples checked.
}


rm -fr $root/out/*

ins="$root/documents"
outs="$root/out"

doit $ins $outs
doit $ins/userguide   $outs/userguide
doit $ins/devguide    $outs/devguide
doit $ins/devopsguide $outs/devopsguide

mkdir $outs/presentations
cp -f $ins/presentations/*.pdf $outs/presentations/

run_tests

echo Done.

tar -czf $APP.$EXT -C $root out
