#!/bin/bash
set -e

echo $ 3-hello.sh
sh 3-hello.sh
echo $ 3-hello-full.sh
sh 3-hello-full.sh

echo $ 4-hosted-load.sh
sh 4-hosted-load.sh
#echo $ 4-hosted-download.sh
#sh 4-hosted-download.sh
echo $ 4-nonhosted-load.sh
sh 4-nonhosted-load.sh
#echo $ 4-nonhosted-wms.sh
#sh 4-nonhosted-wms.sh

sh 5-load-file.sh
