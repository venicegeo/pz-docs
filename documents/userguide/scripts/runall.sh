#!/bin/bash
set -e

. setup.sh

unique() {
    echo `date +"%s"`
}

Test3() {
    echo "---------------- Test3 ----------------"

    echo hello...
    ./hello.sh | grep -q Hello

    echo PASS Test3
}

Test4a() {
    echo "---------------- Test4a ----------------"

    name="yournamehere"
    description="mydescription"
    filename="download.dat"
    
    echo "post-hosted-load..."
    jobId=`./post-hosted-load.sh $name $description | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`./get-job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`./get-data-info.sh $dataId | jq -r '.data.metadata.name'`

    if [ $actual != $name ]
    then
        echo FAIL
        exit 1
    fi
    
    echo "get-hosted-data..."
    ./get-hosted-data.sh $dataId $filename
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

    echo "post-nonhosted-load..."
    jobId=`./post-nonhosted-load.sh $name | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    dataId=`./get-job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`./get-data-info.sh $dataId | jq -r '.data.metadata.name'`

    if [ $actual != $name ]
    then
        echo FAIL
        exit 1
    fi

    echo "post-nonhosted-data-wms..."
    jobId=`./post-nonhosted-data-wms.sh $dataId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 3
    url=`./get-job-info.sh $jobId | jq -r .data.result.deployment.capabilitiesUrl`
    echo "    url: $url"
    html=`curl -S -s "$url"`
    echo "$html" | grep -q "GeoServer Web Feature Service"

    echo PASS Test4b
}

Test5() {
    echo "---------------- Test5 ----------------"

    name=kittens-`unique`
    description="kittens"
    echo "post-hosted-load.sh..."
    jobId=`./post-hosted-load.sh $name $description | jq -r .data.jobId`
    sleep 3
    dataId=`./get-job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    actual=`./get-data-info.sh $dataId | jq -r '.data.metadata.name'`
    if [ $actual != $name ]
    then
        echo FAIL 50
        exit 1
    fi
    
    sleep 5

    echo "search-query.sh..."
    result=`./search-query.sh $name | jq -r '.data[0].dataId'`
    echo "    result: $result"
    if [ "$dataId" != "$result" ]
    then
        echo FAIL 51
        exit 1
    fi

    echo "search-filter..."
    result=`./search-filter.sh $name | jq -r '.data[0].dataId'`
    echo "    result: $result"
    if [ "$dataId" != "$result" ]
    then
        echo FAIL 52
        exit 1
    fi

    echo PASS Test5
}

Test6() {
    echo "---------------- Test6 ----------------"

    echo "register-service.sh..."
    serviceId=`./register-service.sh | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"

    echo "execute-service.sh..."
    jobId=`./execute-service.sh $serviceId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    sleep 5
    dataId=`./get-job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    data=`./get-data-info.sh $dataId | jq -r .data.dataType.content`
    echo "    data: $data"

    echo $data | grep -q Hi

    echo PASS Test6
}

Test7() {
    echo "---------------- Test7 ----------------"

    echo "post-eventtype.sh"
    eventTypeId=`./post-eventtype.sh | jq -r .data.eventTypeId`
    echo "    eventTypeId: $eventTypeId"

    echo "register-service.sh..."
    serviceId=`./register-service.sh  | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"

    echo "post-trigger.sh"
    triggerId=`./post-trigger.sh $eventTypeId $serviceId | jq -r .data.triggerId`
    echo "    triggerId: $triggerId"

    echo "post-event.sh"
    eventId=`./post-event.sh $eventTypeId | jq -r .data.eventId`
    echo "    eventId: $eventId"
    
    sleep 3
    
    echo "get-alerts.sh"
    result=`./get-alerts.sh $triggerId`

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

    echo "register-crop-service.sh..."
    serviceId=`./register-crop-service.sh | jq -r .data.serviceId`
    echo "    serivceId: $serviceId"
    
    sleep 2

    echo "execute-crop-service.sh..."
    jobId=`./execute-crop-service.sh $serviceId | jq -r .data.jobId`
    echo "    jobId: $jobId"
    
    status="Running"
    i=0
    while [ "$status" = "Running" -a $i -lt 60 ]
    do
        sleep 5
        status=`./get-job-info.sh $jobId | jq -r .data.status`
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
    
    dataId=`./get-job-info.sh $jobId | jq -r .data.result.dataId`
    echo "    dataId: $dataId"
    fileName=`./get-data-info.sh $dataId | jq -r .data.dataType.location.fileName`
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
