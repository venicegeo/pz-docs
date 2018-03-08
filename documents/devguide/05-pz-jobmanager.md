# Job Manager

## Job Management Overview

For activities that are potentially time consuming such as the
invocation of user services (e.g. algorithms), the orchestration of user
services and loading of data results, Piazza leverages Apache Kafka for
asynchronous messaging support. Requests are sent to the Gateway as
**Jobs**. The Job Manager component obtains this information and creates
job messages for the Workflow, Service Controller and Ingest components
to obtain and work on. A unique *jobId* is used to track these jobs and
is provided back to the NPE as a response to the job request. NPEs use
the jobId to track the status of their job request. Leveraging Apache
Kafka, the Workflow, Service Controller and Ingest components send
updates about job status. Once the job is complete, data results are
loaded onto S3 or PostGreSQL for NPEs to access.

Endpoints that return a Job ID are documented and outlined in the
Swagger documentation.

    {
        "jobId": "my-job-id"
    }

The response may look something like the above. In this case, the
requesting user can then take the Job ID and re-query the Gateway with
the Job ID in order to get the latest status and progress of that Job.

When the Job has been completed, the result of the associated Job (being
a data ID, or service, or whatever the end result of the Job was) will
be contained in the status of that Job, including the time it was
completed and how long it took.

### Example Job Manager Endpoints

The table below depicts examples of the various endpoints used for job
management.

<table>
	<thead>
		<tr>
			<th>Endpoint</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr class="odd">
			<td>/job</td>
			<td>Get Job Status</td>
		</tr>
		<tr class="even">
			<td>/abort</td>
			<td>Abort Job</td>
		</tr>
		<tr class="odd">
			<td>/repeat</td>
			<td>Repeat Job</td>
		</tr>
	</tbody>
</table>

## Building and Running Locally

Please refer to repository readme: <https://github.com/venicegeo/pz-jobmanager>

## Source Organization

The main logic of the Job Manager is split between two package. The
`controller` package contains the REST controller that contains the REST
endpoints for querying job status, etc. This is a simple Spring
RestController that contains the endpoints defined as simple functions.
The `messaging` package declares the Apache Kafka logic, where the
JobManager defines Kafka consumers to poll for incoming messages. The
messages pertain to 1) Creating new Jobs and 2) Updating the status of
Jobs. The Jobs are persisted in the MongoDB and interaction code to
handle the MongoDB commits is located in the `database` package.

## Interface

The main communication with the Job Manager is via Kafka from messages.
The Gateway sends "Request-Job" messages to the Job Manager in order to
index the running of new jobs. The components that process Jobs will
also send Kafka messages to the Job Manager in order to update the
status of running jobs.

The Job Manager also contains a series of REST endpoints that are used
for obtaining Job Status, or lists of Jobs.

## Piazza Database & Jobs Collection

The MongoDB instance uses a database titled `Piazza` with a single
`Jobs` collection. The interfaces exposed through the Dispatcher
messaging will be simple CRUD-style functionality. The JSON stored in
the Jobs collection will be stored using the [Common
Job](https://github.com/venicegeo/pz-jobcommon).

    {
        "type": "job"
        "jobId": "a10a04af-5e7e-4aea-b7de-f3dbc12e4279"
        "ready": false
        "status": "Submitted",
        "result": {},
        "progress": {
            "percentComplete": null
            "timeRemaining": null
            "timeSpent": null
        }
    }

### Administrative API

The Job Manager provides a series of REST Endpoints that can be used to
query the Job Manager for certain information useful to NPEs and
utilities such as SAK.

Jobs returned through REST Endpoints will follow the JSON Model defined
in the [Job
Class](https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/job/Job.java).

## REST Endpoints

`GET /job/count`  
Gets a count of the Jobs in the Piazza system.

`GET /job`  
Gets all of the Jobs in the Piazza system.

-   page: The start page for the query. Optional, default 0.

-   pageSize: The number of results per page. Optional, default 10.

`GET /job/status/{status}/count`  
Get Jobs Status Counts

-   status: The Status to get the count for.

`GET /job/status/{status}`  
Get Job by Status

-   status: The Status to get the Jobs for.

-   page: The start page for the query. Optional, default 0.

-   pageSize: The number of results per page. Optional, default 10.

`GET /job/userName/{userName}`  
Get Jobs by User ID

-   userName: The API Key of the user to query for Jobs submitted by.

-   page: The start page for the query. Optional, default 0.

-   pageSize: The number of results per page. Optional, default 10.

`GET /admin/stats`  
Administrative Statistics - Return object containing information
regarding the running instance of this component. Currently returns the
number of Jobs held in the Job Table, listed by status.

<!-- -->

    {
        "running": 2,
        "fail": 0,
        "total": 19,
        "submitted": 0,
        "success": 16,
        "pending": 0,
        "cancelled": 0,
        "error": 1
    }

### Job Workflow

The purpose of this page is to document the Workflow of the Piazza Core
Job process, and aims to show how Piazza Jobs are created and processed,
in order to give a better understanding of how the many internal Piazza
Core components communicate.

The concept of a Job is used internally by Piazza to manage long-running
processes that are not able to immediately be returned to a user. The
cases for when Jobs and Job IDs are generated are currently for:

-   Service Execution via the `/job` endpoint.

-   Data Loading via the `/data` and `/data/file` endpoints.

-   GeoServer deployments for Data using the `/deployment` endpoint.

### Job Sequence

The Sequence for Jobs is as follows:

-   User Executes one of the above-mentioned, long-running processes
    through the Gateway.

-   The Gateway validates the Request, and passes the Request-Job topic
    to the Job Manager via Kafka

-   The Job Manager consumes this Kafka message and writes the Job
    metadata to the MongoDB Jobs table. It also forwarded along the
    Kafka topic for that Job.

-   Some internal Worker component (such as Ingest or Access) will
    consume the message.

-   The Worker will periodically update the Job Manager with Status
    Updates as to the progress of the Job. The Job Manager will write
    these updates to the Jobs table.

-   Once done, The Worker will alert the Job Manager that the Job has
    completed.

-   Along the way, the User can query for Job Status by creating another
    `/job` request to the Gateway. This response will give the user the
    progress, and when done, the final Result of the Job.

### How Jobs an be Cancelled

Each Worker component (defined as a Component capable of processing
Jobs), such as Service Controller, Ingest, and Access, will join a
single Kafka consumer group together. By joining the same Kafka consumer
group, this ensures that as each component scales out towards N-number
of instances, only one instance of that component will receive an
incoming Job. In this way, Jobs are spread out among all instances
automatically by Kafka. This group name is often named based on the
component itself, for readability: For example, the `pz-ingest`
component Consumer group is called `ingest`.

However, there is the scenario where Jobs currently being processed by a
Worker Component will need to be cancelled. If there are N-number of
instances of a Worker component, then we’ll need to be able to ensure
that the Worker component handling a specific Job that is to be
cancelled is able to receive the Kafka message requesting the
cancellation. Because of this, the message cannot be consumed by the
general Kafka consumer group mentioned in the above paragraph: this is
due to the fact that in this case, if there are 5 instances of a
Component running, we cannot guarantee that the 1 Component instance
handling the job will be delivered that message by Kafka.

To solve this problem, each Component instance will define **two** Kafka
groups. One group will be the general component Kafka group. This is a
group that all instances of the Component will share, and this is the
group that will consume the messages that relate to Job processing. Each
Component will define a **second** Kafka group that is uniquely named.
Thus, for any specific Component, it may have two groups: One named
`ingest` used for general Job messaging and one uniquely named
`ingest-SOJ87asd68JDS` that will have the ability to react on each and
every message that comes in, and can be used to handle messages such as
Cancelling Jobs.

Worker components will receive Job messages through their general
consumer. Kafka will ensure that only one Component instance will
receive this message, so it is guaranteed that no two instances will
work the same Job. Worker components will receive Cancellation (or other
important messages) through their unique consumer. For cancellations,
every Consumer instance will receive this Kafka message and will have to
use inner component logic to determine if they are the instance who
currently owns that Job; and if so, they must take the action to cancel
the Job.
