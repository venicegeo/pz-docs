# Logger

## Overview

The Logger provides a system-wide, common way to record log messages.
The log messages are stored in Elasticsearch. This is done though an
HTTP API.

## Building and Running Locally To find out how to run the pz-logger
service locally, please visit the github
[README](https://github.com/venicegeo/pz-logger/blob/master/README.md)

## HTTP API

# `POST /syslog`

Sends a message to be logged. The message is given in the POST body as a
JSON object:

    {
        "facility": 1,
        "severity": 7,
        "version": 1,
        "timeStamp": "2017-01-01T10:00:00.255Z",
        "hostName": "128.1.2.3",
        "application": "log-tester",
        "process": "1",
        "messageId": "",
        "auditData": null,
        "metricData": null,
        "sourceData": null,
        "message": "The quick brown fox"
    }

`timeStamp` is a `string` representing the message creation time,
expressed in UTC [RFC 3339](https://www.ietf.org/rfc/rfc3339.txt). (In
Go, `time.Now().Rount(time.Millisecond).UTC().Format(time.RFC3339)`).

`facility` and `version` are 1 by default

`severity` must be one of the following integers:

7 ("Debug")  
Only used during development, for debugging/tracing purposes.

6 ("Info")  
No action needed, I’m just being chatty and keeping you in the loop.

5 ("Notice")  
No *errors*, but further action might be required.

4 ("Warning")  
Something occurred which probably shouldn’t have. I’m going to handle it
for you this time, but you really should have this looked at by someone
soon.

3 ("Error")  
I can’t do this. I’ve handled the exception so I’m not going to crash or
anything, but I want you to know that I may not be in a happy place
right now.

2 ("Fatal")  
I’m sorry, Dave. I’m afraid I can’t do that. System crashing, or likely
to crash very soon.

# `GET /syslog`

Returns a JSON object of log messages:

    {
        "statusCode": 200,
        "data": [
            {
                "facility": 1,
                "severity": 6,
                "version": 1,
                "timeStamp": "2016-07-18T12:43:10.079Z",
                "hostName": "0.0.0.0",
                "application": "notset",
                "process": "",
                "messageId": "",
                "auditData": nil,
                "metricData": nil,
                "sourceData": nil,
                "message": "..."
            },
            {
                "facility": 1,
                "severity": 6,
                "version": 1,
                "timeStamp": "2016-07-18T12:43:09.865Z",
                "hostName": "0.0.0.0",
                "application": "notset",
                "process": "",
                "messageId": "",
                "auditData": nil,
                "metricData": nil,
                "sourceData": nil,
                "message": "..."
            }
        ],
        "pagination": {
            "count": 123,
            "order": "desc",
            "page": 1,
            "perPage": 2,
            "sortBy": "createdOn"
        }
    }

This endpoint supports pagination, as described in [???](#Pagination).

# Common operations

This service includes the common endpoints described in
[???](#Common Endpoints).

The `admin stats` supported are:

    {
        "createdOn": "2016-07-18T12:43:09.865052883Z",
        "numMessages": 1234
    }
