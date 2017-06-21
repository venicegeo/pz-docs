#!/bin/bash -e

do_xtrace=$(echo $SHELLOPTS | grep -o xtrace | cat)
set +x

root=$(pwd -P)

test -n "$RVM_TOOL"    || { echo "$0: RVM_TOOL not defined." >&2; exit 1; }
test -n "$RVM_VERSION" || { echo "$0: RVM_VERSION not defined." >&2; exit 1; }

echo "export rvm_prefix=$root" > $root/.rvmrc
echo "export rvm_path=$root/.rvm" >> $root/.rvmrc
echo "export rvm_bin_path=/$root/.rvm/bin" >> $root/.rvmrc
echo "export rvm_ruby_string=ruby-$RVM_VERSION" >> $root/.rvmrc

rm -rf $root/.rvm

rsync -a $RVM_TOOL/ $root/.rvm

egrep -v '^ *rvm_install ' "$RVM_TOOL/binscripts/rvm-installer" > $root/rvm-installer.source

source $root/rvm-installer.source

rvm_install_select_and_get_version() {
  echo 'Thwarting rvm_install_select_and_get_version.' 1>&2 ;
  cd $RVM_TOOL
}

rvm_install --path "$root/.rvm" > rvm.out 2>&1
[ $? = 0 ] || cat rvm.out

cd $root

source $root/.rvm/scripts/rvm

rvm install $RVM_VERSION > rvm.out 2>&1
[ $? = 0 ] || cat rvm.out

[ -z "$do_xtrace" ] || set -x
