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

###
git clone https://github.com/stedolan/jq.git
cd jq
autoreconf -i
./configure --disable-maintainer-mode --prefix=$root/jq-install
make
make install
ls -R $root/jq-install
PATH=$PATH:$root/jq-install/bin
###

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

    cp "$scripts/terrametrics.tif" "$root"

    echo ; echo ; echo TEST START ; echo ; echo
    pushd $scripts
    "runall.sh"
    popd
    echo ; echo ; echo TEST END ; echo ; echo

    rm -f "$root/terrametrics.tif"

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

run_tests

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
