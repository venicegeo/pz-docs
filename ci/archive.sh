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
    echo "Processing: $bbb/index.txt"

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
    # FIXME these require an auth.sh to be in the PWD
    # $root/documents/userguide/scripts/3-hello.sh
    # $root/documents/userguide/scripts/3-hello-full.sh

    echo "Checking section 4 examples"
    # FIXME these require an auth.sh to be in the PWD
    # cp $root/documents/userguide/scripts/terrametrics.tif $root
    # jobid=`$root/documents/userguide/scripts/4-hosted-load.sh`
    # dataid=`$root/documents/userguide/scripts/4-job.sh $jobid`
    # $root/documents/userguide/scripts/4-hosted-download.sh $dataid
    # jobid=`$root/documents/userguide/scripts/4-nonhosted-load.sh`
    # dataid=`$root/documents/userguide/scripts/4-job.sh $jobid`
    # $root/documents/userguide/scripts/4-nonhosted-wms.sh $dataid
    # rm $root/terrametrics.tif

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

# if errs.tmp is empty, remove it
[ -s "errs.tmp" ] || rm "errs.tmp"

tar -czf $APP.$EXT -C $root out
