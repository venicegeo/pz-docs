#!/bin/sh

# fail if we don't have $DOMAIN set
( printenv DOMAIN > /dev/null ) || ( echo "'$DOMAIN' not set" ; exit 1 )

# given a file name and a string, fail if the doesn't contain the string
function assert_contains {
    file=$1
    str=$2
    grep -q $2 $1 || ( echo "File $1 does not contain $2" ; exit 1 )
}

function assert_not_contains {
    file=$1
    str=$2
    grep -q $2 $1 && ( echo "File $1 does contain $2" ; exit 1 )
}

# given a filename (containing a JSON object), extract and return the value
# of the jobId field (the resource id)
function extract_jobid {
    file=$1
    grep -o '"jobId":".*"' $file | cut -d \" -f 4
    return $id
}

# given a filename (containing a JSON object), extract and return the value
# of the dataId field (the resource id)
function extract_dataid {
    file=$1
    grep -o '"dataId":".*"' $file | cut -d \" -f 4
}

# "-S -s" means show any errors but don't show the progress meter
# "-w" means print the http status code to stdout
# "-o" means send the returned text to the file "response.txt"
curl="curl -S -s -w \"%{http_code}\" -o response.txt"
