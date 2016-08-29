#!/bin/bash
set -e

t3() {
    echo 3-hello.sh...
    sh 3-hello.sh

    echo 3-hello-full.sh...
    sh 3-hello-full.sh
}

t4a() {
    echo "4-hosted-load.sh..."
    jobId=`sh 4-hosted-load.sh`
    echo "    jobId: $jobId"
    sleep 6

    dataId=`sh job-info.sh $jobId | jq .data.result.dataId`
    echo "    dataId: $dataId"

    sh data-info.sh $dataId

    echo "4-hosted-download.sh $dataId..."
    sh 4-hosted-download.sh $dataId
}

t4b() {
    echo "4-nonhosted-load.sh..."
    jobId=`sh 4-nonhosted-load.sh`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`sh job-info.sh $jobId | jq .data.result.dataId`
    echo "    dataId: $dataId"
    sh data-info.sh $dataId

    echo 

    echo "4-nonhosted-wms.sh..."
    jobId=`sh 4-nonhosted-wms.sh $dataId`
    echo "    jobId: $jobId"
    sleep 3
    url=`sh job-info.sh $jobId | jq .data.dataType.capabilitiesUrl`
    echo "    url: $url"
}

t5() {
    sh 5-load-file.sh
}

t6() {
    ls
}

t7() {
    ls
}

t8() {
    ls
}

t3
t4a
t4b

