#!/bin/bash
set -e
. setup.sh

unique() {
    echo `date +"%s"`
}

t3() {
    echo 3-hello-full...
    sh 3-hello-full.sh | grep -q Hello

    echo 3-hello...
    sh 3-hello.sh | grep -q Hello

    echo pass t3
}

t4a() {
    name="yournamehere"
    description="mydescription"
    filename="download.dat"
    
    echo "4-hosted-load..."
    jobId=`sh 4-hosted-load.sh $name | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`sh job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`sh data-info.sh $dataId | jq -r '.data.metadata.name'`

    if [ $actual != $name ]
    then
        echo FAIL
        exit 1
    fi
    
    echo "4-hosted-download..."
    sh 4-hosted-download.sh $dataId $filename
    if [ ! -s $filename ]
    then
        echo FAIL
        exit 1
    fi

    echo pass t4a
}

t4b() {
    name="mynamehere"
    filename=

    echo "4-nonhosted-load..."
    jobId=`sh 4-nonhosted-load.sh $name | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`sh job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`sh data-info.sh $dataId | jq -r '.data.metadata.name'`

    if [ $actual != $name ]
    then
        echo FAIL
        exit 1
    fi

    echo "4-nonhosted-wms..."
    jobId=`sh 4-nonhosted-wms.sh $dataId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    url=`sh job-info.sh $jobId | jq -r .data.result.deployment.capabilitiesUrl`
    echo "    url: $url"
    html=`curl -S -s "$url"`
    echo "$html" | grep -q "GeoServer Web Feature Service"

    echo pass t4b
}

t5() {
    name=kittens`unique`
    echo "5-load-file..."
    jobId=`sh 5-load-file.sh $name | jq -r .data.jobId`
    sleep 3
    dataId=`sh job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`sh data-info.sh $dataId | jq -r '.data.metadata.name'`
    if [ $actual != $name ]
    then
        echo FAIL
        exit 1
    fi

    echo "5-query.sh..."
    result1=`sh 5-query.sh $name | jq -r '.data[0].dataId'`
    echo "    result1: $result1"

    echo "5-filtered-get..."
    result2=`sh 5-filtered-get.sh $name | jq -r '.data[0].dataId'`
    echo "    result2: $result2"

need to verify matches
exit 8
#    echo pass t5
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
    sleep 3
    statusCode=`sh job-info.sh $jobId | jq .data.result.statusCode`
    echo "    statusCode: $statusCode"
}

#t3
#t4a
#t4b
t5
#t6
#t7
#t8
