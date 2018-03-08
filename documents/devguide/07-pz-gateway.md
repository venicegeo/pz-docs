# Gateway

Handles all user-facing requests to Piazza via REST endpoints. The
purpose of this component is to allow for external users to be able to
interact with Piazza data, services, events, and other core Piazza
functionality.

## Building and Running Locally

Please refer to repository readme:<https://github.com/venicegeo/pz-gateway>

## S3 Credentials

The Gateway is responsible for pushing uploaded files (such as for
Ingest jobs) to the Piazza S3 instance. As such, the Gateway containers
will require environment variables to be established for passing in the
values for the S3 Access key and the S3 Private Access key to be used.
These values are referenced in the ENV variables
`vcap.services.pz-blobstore.credentials.access_key_id` and
`vcap.services.pz-blobstore.credentials.secret_access_key`. If you are a
developer and you do not have these values on your host, you will not be
able to Ingest files into the Gateway.

## Code Organization

The Gateway uses a series of Spring RestControllers in order to manage
the number of REST Endpoints that the Gateway API provides. These are
located in the `controller` package, and are broken up into separate
objects by their functionality. The `auth` package defines how Gateway
authenticates users through the `pz-idam` project. The logic for turning
on Authentication is located in the `Application.java` class - this is
handled by either enabling or disabling the `secure` Spring profile. If
this profile is enabled, then authentication is active and will point to
`pz-idam` for basic authentication credentials. If this profile is
disabled, then the Gateway will not require any authentication for
incoming requests.

## Interface

The Gateway API provides a series of REST endpoints that enable users to
work with data, services, events, and triggers. See the Swagger
documentation for a complete documentation and listing for all available
Gateway API endpoints. See Swagger documentation for the Gateway for
specific endpoints, payloads and responses.

## Authentication and Authorization

Authentication and authorization is handled via the `pz-idam` component.
This authentication becomes active when the `secure` Spring profile is
enabled in the Gateway. When authentication, all requests to the Gateway
will require basic authentication (standard base64-encoded) with
usernames and passwords defined in `pz-idam`.

# Job Request

In the case of long-running Jobs, such as Data loading, or Service
execution - the Gateway implements the concept of a Job as a handle to
this long-running process. In cases where a direct result is not able to
be returned through the Gateway, then the user will instead receive a
Job ID. This Job ID is then used to track the progress of the
long-running process as it is handled internally by Piazza components.

Each Job sent to the Piazza system through the Gateway is assigned a
UUID. This UUID is then used to uniquely identify the Job within the
system. This Job ID can then be used to check the status of the
long-running Job process in order to get information such as status,
progress, or time remaining.

The typical request for getting the status of a Job to the Gateway will
look like:

    GET /job/{{jobId}}

This will return any progress, or status information. When the job is
done, this will also contain a `result` field which will contain a
reference to the resulting objects of the Job. The result will look like
the following:

    {
        "type": "status",
        "jobId": "8504ceff-2af6-405b-bd8a-6804e7759676",
        "status": "Submitted",
        "progress": {
            "percentComplete": 50,
            "timeRemaining": null,
            "timeSpent": null
        }
    }

The resulting JSON will contain the current status information for that
Job. The `status` and `progress` objects contain information to the
Job’s current status.

If the Job has encountered an error, then this information will also be
available in the resulting JSON.

## Job Abort

Users who submit a Job that is currently running, can request that Job
be cancelled using the DELETE operation on the `job` endpoint. This will
dispatch the event throughout the Piazza application that all components
handling this Job should stop immediately.

    DELETE /job/{{jobId}}

## REST API

Please see the Jobs section in this document for more information on the
specific endpoints that the Gateway provides. For live documentation,
see the Swagger files.
