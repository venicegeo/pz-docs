#!/bin/bash
# Script used to generate different flavors of the Developers Guide
# One for the open source community and one for the pz-core team

set -e

pushd "$(dirname "$0")/.." > /dev/null
root=$(pwd -P)

echo "THE ROOT DIR IS "
echo "$root"
popd > /dev/null

hash asciidoctor >/dev/null 2>&1 || gem install asciidoctor
hash asciidoctor-pdf >/dev/null 2>&1 || gem install --pre asciidoctor-pdf

# shellcheck disable=SC1090
source "$root/scripts/vars.sh"

function doit {
    indir=$1
    outdir=$2

    aaa=$(dirname "$indir/index.txt")
    bbb=$(basename "$aaa")
    echo "Processing: $bbb/index.txt"

    # txt -> html
    asciidoctor -o "$outdir/index.html" "$indir/index.txt"  &> errs.tmp
    asciidoctor -o "$outdir/index-pzcore.html" "$indir/index-pzcore.txt"  &> errs.tmp
    if [ -s errs.tmp ] ; then
        cat errs.tmp
        exit 1
    fi

    # txt -> pdf
    asciidoctor -r asciidoctor-pdf -b pdf -o "$outdir/index.pdf" "$indir/index.txt"  &> errs.tmp
    if [ -s errs.tmp ] ; then
        cat errs.tmp
        exit 1
    fi

    # copy images directory to out dir
    cp -R "$indir/images" "$outdir"

    # copy scripts directory to out dir
    cp -R "$indir/scripts" "$outdir"
}


# shellcheck disable=SC2086
rm -rf $root/out/*

ins="$root"
outs="$root/out"

doit "$ins" "$outs/devguide"

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
