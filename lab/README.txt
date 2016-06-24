sh 3a-hello.sh
sh 3b-hello.sh

sh 4a-hosted-load.sh
sh job-info.sh JOB_ID
sh data-info.sh DATA_ID

sh 4b-hosted-download.sh DATA_ID

#sh 4c-nonhosted-wms.sh DATA_ID
#sh job-info.sh JOB_ID

sh 5a-load-file.sh NAME DESCRIPTION
sh job-info.sh JOB_ID
sh data-info.sh dataId
sh 5b-filtered-get.sh SEARCH_TERM

sh 6a-register.sh
sh 6b-execute-get.sh SERVICE_ID

DOMAIN=int.geointservices.io
sh 7a-eventtype.sh
sh 7b-trigger.sh EVENTTYPE_ID SERVICE_ID
sh 7c3-event.sh EVENTTYPE_ID
#sh 7d-get-alerts.sh
