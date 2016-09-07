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


function install_aspell {
    target=$root/aspell-bin
    mkdir $target
    curl ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz > aspell-0.60.6.1.tar.gz
    tar xzf aspell-0.60.6.1.tar.gz
    pushd aspell-0.60.6.1
    ./configure --prefix=$target && make
    make install
    ls -R $target

    curl ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2016.06.26-0.tar.bz2 > aspell6-en-2016.06.26-0.tar.bz2
    bunzip2 aspell6-en-2016.06.26-0.tar.bz2
    tar xf aspell6-en-2016.06.26-0.tar
    cd aspell6-en-2016.06.26-0
    ./configure --vars ASPELL=$target/aspell-bin/bin/aspell #--prefix=$target
    make
    make install
    popd
}

function spell_check {
    sh $root/etc/spellcheck.sh
}


function build_docs {
    indir=$1
    outdir=$2

    aaa=$(dirname "$indir/index.txt")
    bbb=$(basename "$aaa")
    echo "Processing: $bbb/index.txt"

    # insert build date
    dat=`date "+%Y-%m-%d"`
    dattim=`date "+%Y-%m-%d %H:%M:%S %Z"`
    sed "s/__DATE__/$dat/g" "$indir/index.txt" > "$indir/index.txt.2"

    # txt -> html
    asciidoctor -o "$outdir/index.html" "$indir/index.txt.2"  &> errs.tmp
    if [[ -s errs.tmp ]] ; then
        cat errs.tmp
        exit 1
    fi

    # txt -> pdf
    asciidoctor -r asciidoctor-pdf -b pdf -o "$outdir/index.pdf" "$indir/index.txt.2"  &> errs.tmp
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
    ./runall.sh
    popd
    echo ; echo ; echo TEST END ; echo ; echo

    rm -f "$root/terrametrics.tif"

    echo "Testing completed"
}

install_aspell

spell_check

[[ -d "$outs" ]] && rm -rf "$outs"
mkdir "$outs"

build_docs "$ins" "$outs"
build_docs "$ins/userguide"   "$outs/userguide"
build_docs "$ins/devguide"    "$outs/devguide"

mkdir "$outs/presentations"
# shellcheck disable=SC2086
cp -f $ins/presentations/*.pdf "$outs/presentations/"

# Can't run the tests because we don't have an API key.
#run_tests

echo Done.

tar -czf "$APP.$EXT" -C "$root" out
