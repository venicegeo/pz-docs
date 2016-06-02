#!/bin/bash
#set -e

[[ -f "$scripts/setup.sh" ]] && . "$scripts/setup.sh"

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)
popd > /dev/null

ins="$root/documents"
outs="$root/out"
scripts="$root/documents/userguide/scripts"

hash asciidoctor >/dev/null 2>&1 || gem install asciidoctor
hash asciidoctor-pdf >/dev/null 2>&1 || gem install --pre asciidoctor-pdf

source "$root/ci/vars.sh"

function doit {
    indir=$1
    outdir=$2

    aaa=$(dirname "$indir/index.txt")
    bbb=$(basename "$aaa")
    echo "Processing: $bbb/index.txt"

    # txt -> html
    asciidoctor -o "$outdir/index.html" "$indir/index.txt"  &> errs.tmp
    if [[ -s errs.tmp ]] ; then
        cat errs.tmp
        exit 1
    fi

    # txt -> pdf
    asciidoctor -r asciidoctor-pdf -b pdf -o "$outdir/index.pdf" "$indir/index.txt"  &> errs.tmp
    if [[ -s errs.tmp ]] ; then
        cat errs.tmp
        exit 1
    fi

    # if errs.tmp is empty, remove it
    [[ -s "errs.tmp" ]] || rm "errs.tmp"

    # copy images directory to out dir
    cp -R "$indir/images" "$outdir"

    # copy scripts directory to out dir
    cp -R "$indir/scripts" "$outdir"
}


function run_tests {
    # verify the example scripts
    echo
    echo "Checking examples."

    echo
    echo "Checking section 3 examples"
    echo "- Checking 3-hello.sh"
    sh "$scripts/3-hello.sh"
    echo "- Checking 3-hello-full.sh"
    sh "$scripts/3-hello-full.sh"

    echo
    echo "Checking section 4 examples"
    cp "$scripts/terrametrics.tif" "$root"
    echo "- Checking 4-hosted-load.sh"
    jobid=$(sh "$scripts/4-hosted-load.sh")
    echo "- Checking 4-job.sh"
    dataid=$(sh "$scripts/4-job.sh" "$jobid")
    echo "- Checking 4-hosted-download.sh"
    sh "$scripts/4-hosted-download.sh" "$dataid"
    rm "$root/terrametrics.tif"

    # echo "- Checking 4-nonhosted-load.sh"
    # jobid=`$scripts/4-nonhosted-load.sh`
    # echo "- Checking 4-job.sh"
    # dataid=`$scripts/4-job.sh $jobid`
    # echo "- Checking 4-nonhosted-wms.sh"
    # jobid=`$scripts/4-nonhosted-wms.sh $dataid`
    # # check to make sure our wms gets set up
    # $scripts/4-job.sh $jobid

    # echo
    # echo "Checking section 5 examples"

    # echo
    # echo "Checking section 6 examples"

    # echo
    # echo "Checking section 7 examples"

    # echo
    # echo "Checking section 8 examples"

    # echo
    echo "Examples checked."
}

[[ -d "$outs" ]] && rm -rf "$outs"

mkdir "$outs"

doit "$ins" "$outs"
doit "$ins/userguide"   "$outs/userguide"
doit "$ins/devguide"    "$outs/devguide"
doit "$ins/devopsguide" "$outs/devopsguide"

mkdir "$outs/presentations"
cp -f $ins/presentations/*.pdf "$outs/presentations/"

run_tests

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
