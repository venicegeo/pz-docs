#!/bin/bash

. setup.sh

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
    jobId=`sh 4-nonhosted-wms.sh $dataId | jq .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    url=`sh job-info.sh $jobId | jq .data.result.deployment.capabilitiesUrl`
    echo "    url: $url"
}

t5() {
    echo "5-load-file.sh..."
    dataId=`sh 5-load-file.sh NAME KITTENS`
    echo "    ...$dataId"
    sh data-info.sh $dataId

    echo "5-load-files.sh..."
    sh 5-load-files.sh

    echo "5-query.sh..."
    sh 5-query.sh KITTENS

    echo "5-filtered-get.sh..."
    sh 5-filtered-get.sh KITTENS
}

t6() {
    echo "6-register.sh..."
    serviceId=`sh 6-register.sh`
    echo "    serivceId: $serviceId"

    echo "6-execute-get.sh..."
    jobId=`sh 6-execute-get.sh $serviceId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`sh job-info.sh $jobId | jq .data.result.dataId`
    echo "    dataId: $dataId"
    data=`sh data-info.sh $dataId | jq .data.dataType.content`
    echo "    data: $data"
}

t7() {
    echo "7-eventtype.sh"
    eventTypeId=`sh 7-eventtype.sh`
    echo "    eventTypeId: $eventTypeId"

    echo "6-register.sh..."
    serviceId=`sh 6-register.sh`
    echo "    serivceId: $serviceId"

    echo "7-trigger.sh"
    triggerId=`sh 7-trigger.sh $eventTypeId $serviceId`
    echo "    triggerId: $triggerId"

    echo "7-event.sh"
    eventId=`sh 7-event.sh $eventTypeId`
    echo "    eventId: $eventId"
    
    sleep 3
    
    echo "7-get-alerts.sh"
    sh 7-get-alerts.sh
}

t8() {
    echo "8-register-crop.sh..."
    serviceId=`sh 8-register-crop.sh`
    echo "    serivceId: $serviceId"
    
    sleep 2

    echo "8-crop-file.sh..."
    jobId=`sh 8-crop-file.sh $serviceId external-public-access-test elevation.tif`
    echo "    jobId: $jobId"
}

#t3
#t4a
#t4b
#t5
#t6
#t7
t8
