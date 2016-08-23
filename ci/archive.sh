#!/bin/bash
set -e

# shellcheck disable=SC1090
[[ -f "$scripts/setup.sh" ]] && source "$scripts/setup.sh"

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)
popd > /dev/null

ins="$root/documents"
outs="$root/out"
scripts="$root/documents/userguide/scripts"

hash asciidoctor >/dev/null 2>&1 || gem install asciidoctor
hash asciidoctor-pdf >/dev/null 2>&1 || gem install --pre asciidoctor-pdf

# shellcheck disable=SC1090
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
    echo "Testing started"

    # Check our environment variables
    "$scripts/setup.sh"

    cp "$scripts/terrametrics.tif" "$root"

    echo -n "  3-hello.sh... "
    "$scripts/3-hello.sh" > /dev/null
    echo pass

    echo -n "  3-hello-full.sh... "
    "$scripts/3-hello-full.sh" > /dev/null
    echo pass

    echo -n "  4-hosted-load.sh... "
    jobid=$("$scripts/4-hosted-load.sh")
    sleep 5
    dataid=$("$scripts/job-info.sh" "$jobid")
    echo pass

    echo -n "  4-hosted-download.sh... "
    "$scripts/4-hosted-download.sh" "$dataid" > /dev/null
    echo pass

    echo -n "  4-nonhosted-load.sh... "
    jobid=$("$scripts/4-nonhosted-load.sh")
    sleep 5
    dataid=$("$scripts/job-info.sh" "$jobid")
    echo pass

    echo -n "  4-nonhosted-wms.sh... "
    jobid=$("$scripts/4-nonhosted-wms.sh" "$dataid")
    sleep 5
    "$scripts/job-info.sh" "$jobid" > /dev/null
    echo pass

    echo -n "  5-load-file.sh... "
    # Load manually because relative paths are hard ...
    "$scripts/5-load-file.sh" "one" "The quick, brown fox." > /dev/null
    "$scripts/5-load-file.sh" "two" "The lazy dog." > /dev/null
    "$scripts/5-load-file.sh" "three" "The hungry hungry hippo." > /dev/null
    echo pass

    echo -n "  5-filtered-get.sh... "
    "$scripts/5-filtered-get.sh" "dog" > /dev/null
    echo pass

    echo -n "  5-query.sh... "
    "$scripts/5-query.sh" "fox" > /dev/null
    echo pass

    echo -n "  6-register.sh... "
    reg=$("$scripts/6-register.sh")
    echo pass

    echo -n "  6-execute-get.sh... "
    exe=$("$scripts/6-execute-get.sh" "$reg")
    sleep 5
    job=$("$scripts/job-info.sh" "$exe")
    "$scripts/data-info.sh" "$job" > /dev/null
    echo pass

    echo -n "  7-eventtype.sh... "
    eventtype=$("$scripts/7-eventtype.sh")
    echo pass

    echo -n "  7-trigger.sh... "
    "$scripts/7-trigger.sh" "$eventtype" > /dev/null
    echo pass

    echo -n "  7-event.sh... "
    "$scripts/7-event.sh" "$eventtype" > /dev/null
    echo pass

    echo -n "  7-get-alerts.sh... "
    "$scripts/7-get-alerts.sh" > /dev/null
    echo pass

    echo -n "  8 (end-to-end)... "
    echo "*** SKIPPED ***"

    rm "$root/terrametrics.tif"

    echo "Testing completed"
}

[[ -d "$outs" ]] && rm -rf "$outs"

mkdir "$outs"

doit "$ins" "$outs"
doit "$ins/userguide"   "$outs/userguide"
doit "$ins/devguide"    "$outs/devguide"
doit "$ins/devopsguide" "$outs/devopsguide"

mkdir "$outs/presentations"
# shellcheck disable=SC2086
cp -f $ins/presentations/*.pdf "$outs/presentations/"

#run_tests

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
