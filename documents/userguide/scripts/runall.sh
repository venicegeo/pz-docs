#!/bin/bash
set -e
. ./setup.sh

unique() {
    echo `date +"%s"`
}

Test3() {
    echo "---------------- Test3 ----------------"

    echo 3-hello-full...
    sh 3-hello-full.sh | grep -q Hello

    echo 3-hello...
    sh 3-hello.sh | grep -q Hello

    echo PASS Test3
}

Test4a() {
    echo "---------------- Test4a ----------------"

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

    echo PASS Test4a
}

Test4b() {
    echo "---------------- Test4b ----------------"

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

    echo PASS Test4b
}

Test5() {
    echo "---------------- Test5 ----------------"

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
    result=`sh 5-query.sh $name | jq -r '.data[0].dataId'`
    echo "    result: $result"
    if [ "$dataId" != "$result" ]
    then
        echo FAIL
        exit 1
    fi

    echo "5-filtered-get..."
    result=`sh 5-filtered-get.sh $name | jq -r '.data[0].dataId'`
    echo "    result: $result"
    if [ "$dataId" != "$result" ]
    then
        echo FAIL
        exit 1
    fi

    echo PASS Test5
}

Test6() {
    echo "---------------- Test6 ----------------"

    echo "6-register.sh..."
    serviceId=`sh 6-register.sh | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"

    echo "6-execute-get.sh..."
    jobId=`sh 6-execute-get.sh $serviceId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`sh job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    data=`sh data-info.sh $dataId | jq -r .data.dataType.content`
    echo "    data: $data"

    echo $data | grep -q Hi

    echo PASS Test6
}

Test7() {
    echo "---------------- Test7 ----------------"

    echo "7-eventtype.sh"
    eventTypeId=`sh 7-eventtype.sh | jq -r .data.eventTypeId`
    echo "    eventTypeId: $eventTypeId"

    echo "6-register.sh..."
    serviceId=`sh 6-register.sh  | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"

    echo "7-trigger.sh"
    triggerId=`sh 7-trigger.sh $eventTypeId $serviceId | jq -r .data.triggerId`
    echo "    triggerId: $triggerId"

    echo "7-event.sh"
    eventId=`sh 7-event.sh $eventTypeId | jq -r .data.eventId`
    echo "    eventId: $eventId"
    
    sleep 3
    
    echo "7-get-alerts.sh"
    result=`sh 7-get-alerts.sh $triggerId`

    resultTriggerId=`echo $result | jq -r .data[0].triggerId`
    resultEventId=`echo $result | jq -r .data[0].eventId`

    echo "    resultTriggerId: $resultTriggerId"
    if [ "$triggerId" != "$resultTriggerId" ]
    then
        echo FAIL
        exit 1
    fi

    echo "    resultEventId: $resultEventId"
    if [ "$eventId" != "$resultEventId" ]
    then
        echo FAIL
        exit 1
    fi

    echo PASS Test7
}

Test8() {
    echo "---------------- Test8 ----------------"

    echo "8-register-crop.sh..."
    serviceId=`sh 8-register-crop.sh | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"
    
    sleep 2

    echo "8-crop-file.sh..."
    jobId=`sh 8-crop-file.sh $serviceId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    
    status="Running"
    i=0
    while [ "$status" = "Running" -a $i -lt 60 ]
    do
        sleep 5
        status=`sh job-info.sh $jobId | jq -r .data.status`
        i=$[$i+5]
        echo "    $status $i"
    done

    if [ "$status" == "Success" ]
    then
        echo $status $i
    else
        echo FAIL $status $i
        exit 1
    fi
    
    dataId=`sh job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    fileName=`sh data-info.sh $dataId | jq -r .data.dataType.location.fileName`
    echo "    fileName: $fileName"
    echo "$fileName" | grep -q tif

    echo PASS Test8
}

Test3
Test4a
Test4b
Test5
Test6
Test7
Test8
