#!/bin/bash
#set -e

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
    echo "Checking examples."
    # Needed for some tests
    cp "$scripts/terrametrics.tif" "$root"

    # Check our environment variables
    sh "$scripts/setup.sh"

    echo
    echo "Checking section 3 examples"
    echo "- Checking 3-hello.sh"
    sh "$scripts/3-hello.sh" > /dev/null
    echo "- Checking 3-hello-full.sh"
    sh "$scripts/3-hello-full.sh" > /dev/null

    echo
    echo "Checking section 4 examples"
    echo "- Checking 4-hosted-load.sh"
    jobid=$(sh "$scripts/4-hosted-load.sh")
    dataid=$(sh "$scripts/job-info.sh" "$jobid")
    echo "- Checking 4-hosted-download.sh"
    sh "$scripts/4-hosted-download.sh" "$dataid" > /dev/null

    echo "- Checking 4-nonhosted-load.sh"
    jobid=$("$scripts/4-nonhosted-load.sh")
    dataid=$("$scripts/job-info.sh" "$jobid")
    sleep 2
    echo "- Checking 4-nonhosted-wms.sh"
    jobid=$("$scripts/4-nonhosted-wms.sh" "$dataid")
    sh "$scripts/job-info.sh" "$jobid" > /dev/null

    echo
    echo "Checking section 5 examples"
    echo "- Checking 5-load-file.sh"
    # Load manually because relative paths are hard ...
    sh "$scripts/5-load-file.sh" "one" "The quick, brown fox." > /dev/null
    sh "$scripts/5-load-file.sh" "two" "The lazy dog." > /dev/null
    sh "$scripts/5-load-file.sh" "three" "The hungry hungry hippo." > /dev/null
    echo "- Checking 5-filtered-get.sh"
    sh "$scripts/5-filtered-get.sh" "dog" > /dev/null
    echo "- Checking 5-query.sh"
    sh "$scripts/5-query.sh" "fox" > /dev/null

    echo
    echo "Checking section 6 examples"
    echo "- Checking 6-register.sh"
    reg=$(sh "$scripts/6-register.sh")
    echo "- Checking 6-execute-get.sh"
    exe=$(sh "$scripts/6-execute-get.sh" "$reg")
    job=$(sh "$scripts/job-info.sh" "$exe")
    sh "$scripts/file-info.sh" "$job" > /dev/null

    echo
    echo "Checking section 7 examples"
    sh "$scripts/7-example.sh" > /dev/null

    echo
    echo "Not checking section 8 examples"

    # Cleanup
    rm "$root/terrametrics.tif"
    echo
    echo "Examples checked."
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

run_tests

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
