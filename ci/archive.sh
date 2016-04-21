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
    asciidoctor -o $outdir/index.html $indir/index.txt > stdout.tmp
    asciidoctor -r asciidoctor-pdf -b pdf -o $outdir/index.pdf $indir/index.txt
}

rm -f $root/out/*.html $root/out/*/*.html
rm -f $root/stdout.tmp

ins="$root/documents"
outs="$root/out"

doit $ins $outs
doit $ins/userguide   $outs/userguide
doit $ins/devguide    $outs/devguide
doit $ins/devopsguide $outs/devopsguide

# copy images directory to out
cp -R $ins/images $outs/images

echo done

tar -czf $APP.$EXT -C $root out
