\# Workflow Service

Piazza provides the ability for users to define and send an *event*,
representing an event that has happened. These events can be issued
either from within Piazza or by an external client. Piazza also allows
for users to define *triggers*, containing both an event-condition and
an action; when the condition is met, the action is performed. Event
types, events, and triggers can be used to define *workflows* when taken
together.

\#\# The EventType

The user first defines an event type that is the schema for the events
that the user will be generating. The event type object is sent in a
`POST` request to the `/eventType` endpoint and contains a unique `name`
(string) and a mapping describing the EventType’s parameters. For
example:

    {
        "name": "testevent-1468849135",
        "mapping": {
            "filename": "string",
            "code":     "string",
            "severity": "integer"
        }
    }

The `name` must be unique across all event types in the system. Our
practice is to use a namespace prefix, followed by colon (`:`), before
the name.

The available data types are `string`, `boolean`, `integer`, `double`,
`date`, `float`, `byte`, `short`, and `long`. By no coincidence, these
are the basic types that Elasticsearch supports.

This script shows an example of registering an EventType.

[post-eventtype.sh](scripts/post-eventtype.sh)

    #!/bin/bash
    set -e
    . setup.sh

    # tag::public[]
    eventtype='{
        "name": "test-'"$(date +%s)"'",
        "mapping": {
            "ItemId": "string",
            "Severity": "integer",
            "Problem": "string"
        }
    }'

    $curl -X POST -d "$eventtype" $PZSERVER/eventType
    # end::public[]

Note we use the current date/time to generate a unique ID.

Run the script simply as:

    $ ./post-eventtype.sh

\# System EventTypes

Piazza provides some system-level event types — `piazza:ingest` and
`piazza:executionComplete`. These two system event types can be used to
set up triggers that execute something is ingested or an execution has
finished. Those two event types look like the following:

    "piazza:ingest" : {
      "DataId":   "string",
      "DataType": "string",
      "epsg":     "short",
      "minX":     "long",
      "minY":     "long",
      "maxX":     "long",
      "maxY":     "long",
      "hosted":   "boolean",
    }

and

    "piazza:executionComplete" : {
      "JobId":    "string",
      "status":   "string",
      "DataId":   "string",
    }

An event of type `piazza:ingest` will be automatically `POST` -ed by the
system after a file or image is loaded into Piazza.

An event of type `piazza:executionComplete` will be automatically `POST`
-ed by the system when the User Service Registry completes an execution
of a service.

To use these system events, look up the EventType ID for the system
event type with the `/eventType?name=NAME`, where `NAME` is the
EventType name. The return data value will be an array with a single
event type in it. You can get the EventType ID from the event type that
is returned, and create your trigger with that EventType ID.

\#\# The Trigger

Given an event type, the user next defines a trigger to define what
action is to be taken when a specific event occurs. The trigger is sent
as a `POST` request to the `/trigger` endpoint and contains four parts:

-   The `condition` defines what type of event is to be watched for and
    what the specific parameters of that event should be, expressed
    using Elasticsearch DSL query syntax against the parameters in the
    event type.

-   The `job` defines what action is to be taken.

-   The `title` is a memorable string for describing what the trigger is
    meant to do.

-   The `enabled` field determines if the trigger should be listening
    for events in order to send alerts.

For example:

    {
        "title": "High Severity",
        "enabled": true,
        "eventTypeId": "98fc25e8-bd97-4444-a972-c06aa0f0edf1",
        "condition": {
            "query": {
                "query": {
                    "bool": {
                        "must": [
                            { "match": {"severity": 5} },
                            { "match": {"code": "PHONE"} }
                        ]
                    }
                }
            }
        },
        "job": {
            "jobType": {
                "type": "execute-service",
                "data": {
                    "serviceId": "a2898bcb-2646-4ffd-9da7-2308cb7e77d7",
                    "dataInputs": {
                        "test": {
                            "content": "{ \"log\": \"Received code $code with severity $severity\" }",
                            "type": "body",
                            "mimeType": "application/json"
                        }
                    },
                    "dataOutput": [ {
                        "mimeType":"image/tiff",
                        "type":"raster"
                    } ]
                }
            }
        }
    }

For details on the meanings of each field, please consult the Swagger
reference page. For details on constructing valid Elasticsearch DSL
queries, see the [???](#Elasticsearch Query Syntax) section.

In the following example, the job will be executed only when our "test"
event occurs with the `severity` equal to `5` and the `code` equal to
`"PHONE"`.

It is important to note that the `job` field uses substitution by
replacing all instances of `$field`, where `field` is the name of a JSON
field in the event type `mapping` (and therefore is in the event’s
`data` field) with the `field` in the event that sets off the trigger.
This substitution occurs in all of the fields in `job`, so it is
important to be conscious of this.

This script will create a generic trigger for the event type associated
with that `eventTypeId`:

[post-trigger.sh](scripts/post-trigger.sh)

    #!/bin/bash
    set -e
    . setup.sh

    check_arg $1 eventTypeId
    check_arg $2 serviceId

    # tag::public[]
    eventTypeId=$1
    erviceId=$2

    trigger='{
        "name": "High Severity",
        "eventTypeId": "'"$eventTypeId"'",
        "condition": {
            "query": { "query": { "match_all": {} } }
        },
        "job": {
            "userName": "test",
            "jobType": {
                "type": "execute-service",
                "data": {
                    "serviceId": "'"$serviceId"'",
                    "dataInputs": {},
                    "dataOutput": [
                        {
                            "mimeType": "application/json",
                            "type": "text"
                        }
                    ]
                }
            }
        },
        "enabled": true
    }'

    $curl -X POST -d "$trigger" $PZSERVER/trigger
    # end::public[]

To execute, pass the script an EventType ID:

    $ ./post-trigger.sh {{eventTypeId}}

\#\# The Event

The user may create an event of that event type to indicate some
interesting condition has occurred. The event object is sent as a `POST`
request to the `/event` endpoint, and contains the `eventTypeId` of the
event type and the parameters of the event. For example, a request may
look like:

    {
        "eventTypeId": "98fc25e8-bd97-4444-a972-c06aa0f0edf1",
        "data": {
            "filename": "dataset-c",
            "severity": 5,
            "code": "PHONE"
        }
    }

\# Scheduled Events

An event can specify a `cronSchedule` field, which alters the mechanics
of the event-triggering process. The cronSchedule field specifies a
schedule that will be repeated for the specified event. This schedule is
created as a Unix `cron(1)` expression. Users who are unfamiliar with
cron expressions should check the main pages for cron, either via
`man cron`, `man crontab`, or by searching online for cron-related
resources.

Note  
For information on `cron(1)`, see
[cronmaker.com](http://www.cronmaker.com/) and
[crontab.guru](http://crontab.guru/). The cron specification being used
in our implementation is spelled out in
<https://github.com/robfig/cron/blob/master/doc.go>. This differs
slightly from traditional `cron(1)` syntax in that the first asterisk is
the seconds field. This means:

-   `"cronSchedule": "* * * * * *"` - send the event every second

-   `"cronSchedule": "30 * * * * *"` - send the event every minute at
    the 30 second mark

-   `"cronSchedule": "* 30 * * * *"` - send the event every hour at the
    30 minute mark, etc.

The six stars in the cronSchedule stand for:

**seconds | minutes | hours | day of month | month | day of week**

In some cron implementations, the rightmost asterisks can be omitted
from the notation; this is not the case with the particular flavor of
cron we are using.

Cron schedules can be spelled out using shorthand notation:

<table>
<caption>Shorthands</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>Entry</p></td>
<td><p>Description</p></td>
<td><p>Equivalent To</p></td>
</tr>
<tr class="even">
<td><p><code>@yearly</code> (or <code>@annually</code>)</p></td>
<td><p>Run once a year, midnight, Jan. 1st</p></td>
<td><p><code>0 0 0 1 1 *</code></p></td>
</tr>
<tr class="odd">
<td><p><code>@monthly</code></p></td>
<td><p>Run once a month, midnight, first of month</p></td>
<td><p><code>0 0 0 1 * *</code></p></td>
</tr>
<tr class="even">
<td><p><code>@weekly</code></p></td>
<td><p>Run once a week, midnight on Sunday</p></td>
<td><p><code>0 0 0 * * 0</code></p></td>
</tr>
<tr class="odd">
<td><p><code>@daily</code> (or <code>@midnight</code>)</p></td>
<td><p>Run once a day, midnight</p></td>
<td><p><code>0 0 0 * * *</code></p></td>
</tr>
<tr class="even">
<td><p><code>@hourly</code></p></td>
<td><p>Run once an hour, beginning of hour</p></td>
<td><p><code>0 0 * * * *</code></p></td>
</tr>
</tbody>
</table>

A cron schedule can be specified using the `@every duration` notation,
where duration is replaced by a Go-parsable
[time.Duration](https://golang.org/pkg/time/#Duration). Examples
include:

-   `"cronSchedule": "@every 1h30m10s"` - send event every 1 hour, 30
    minutes, 10 seconds

-   `"cronSchedule": "@every 30s"` - send event every 30 seconds

-   `"cronSchedule": "@every 5m"` - send event every 5 minutes

It is crucial to understand that an event that is sent with a cron
schedule is not `POST` -ed into the system in the same way as a typical
event. Rather, it sets up a recurring event that will be sent according
to the schedule specified. If you require an event to be both sent now
as well as on a particular schedule, it is wise to send both a
non-repeating event and a repeating event.

In order to stop repeating events, `DELETE` the initial repeating event
by its event ID.

    DELETE /event/{{EventId}}

The following script will `POST` an event with a given EventType ID:

[post-event.sh](scripts/post-event.sh)

    #!/bin/bash
    set -e
    . setup.sh

    check_arg $1 eventTypeId

    # tag::public[]
    eventTypeId=$1

    event='{
        "eventTypeId": "'"$eventTypeId"'",
        "data": {
            "ItemId": "test",
            "Severity": 200,
            "Problem": "us-bbox"
        }
    }'

    $curl -X POST -d "$event" $PZSERVER/event
    # end::public[]

Execute the script as:

    $ ./post-event.sh {{eventTypeId}}

\#\# The Alert

Whenever the condition of a trigger is met, the system will create an
alert object. The user can `GET` a list of alerts from the `/alert`
endpoint. The alert object contains the ids of the trigger that was hit
and the event which caused it. It also contains a generated `AlertId`.
For example:

    {
        "statusCode": 200,
        "type": "alert-list",
        "data": [
        {
            "AlertId": "58d1ad21-75d0-4ee4-8429-c687b9249cc5",
            "TriggerId": "170619d6-8f4e-4dc4-bcb6-8b0862e0138f",
            "EventId": "baa98fc7-f282-4caf-b35d-c2050eca010c",
            "JobId": "ab62ae7e-432b-4b61-a831-4a80b6ce836e",
            "createdBy": "",
            "createdOn": "2016-07-18T13:41:28.571761514Z"
        }
        ],
        "pagination": {
            "count": 1,
            "page": 0,
            "perPage": 10,
            "sortBy": "alertId",
            "order": "asc"
        }
    }

The following script gets the list of alerts currently in the Piazza
system:

[get-alerts.sh](scripts/get-alerts.sh)

    #!/bin/bash
    set -e
    . setup.sh

    check_arg $1 triggerId

    # tag::public[]
    triggerId=$1

    $curl -X GET $PZSERVER/alert?triggerId=$triggerId
    # end::public[]

The query parameter `?TriggerId=id` is provided on the endpoint to allow
the list to be filtered to only alerts set off by a specified trigger.

To execute:

    $ ./get-alerts.sh TRIGGER_ID

\#\# Workflow API Documentation

See <http://pz-swagger.venicegeo.io/#/Workflow>
