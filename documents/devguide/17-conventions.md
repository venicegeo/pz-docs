# Coding Conventions

## General

-   Piazza APIs SHALL use [RFC
    4122](https://www.ietf.org/rfc/rfc4122.txt) for UUIDs.

-   Piazza APIs SHALL use [ISO
    8601](https://www.w3.org/TR/NOTE-datetime) for time/date formatting.

-   At the root of every [VeniceGeo](https://github.com/venicegeo) open
    source repository, please include this file:
    <https://github.com/venicegeo/venice/blob/master/legal/LICENSE.txt>

-   In the header of every piece of source code in an open source
    repository, include this snippet:
    <https://github.com/venicegeo/venice/blob/master/legal/LICENSE-HEADER.txt>

## Java

For general Java coding, follow the Google Java Style coding standards:
<http://google.github.io/styleguide/javaguide.html>

The package naming convention should be:

-   Piazza Project: `org.venice.piazza.[component name]`

## Go

## Unit Testing

## GitHub

New GitHub Repositories within the
[github.com/venicegeo](https://github.com/venicegeo) community should be
named using following convention:

-   Core Piazza Components: `pz-[COMPONENT NAME]`

-   VeniceGeo Services: `pzsvc-[COMPONENT NAME]`

## REST API Conventions

# JSON Conventions

All input and output payloads will be JSON.

Our default JSON style guide is the [Google JSON style
guide](https://google.github.io/styleguide/jsoncstyleguide.xml).

Our field names will use `lowerCamelCase`, not `under_scores`.

# JSON Fields

Fields containing resource ids should be named according to the resource
type. For example, use `eventId`, not just `id`.

For fields containing "timestamp" information, use names of the form
`<op>edOn`, e.g. `createdOn` or `updatedOn`. The values should be ISO
8601 strings; do not use Unix-style milliseconds-since-epoch.

Field names should be spelled with `lowerCamelCase`. Not
`UpperCamelCase` and not `underscore_style`.

# Pagination

`GET` requests that return arrays (or maps) of objects should typically
support these query parameters for pagination:

-   `?page=INT`

-   `?perPage=INT`

-   `?sortBy=STRING`

-   `?order=STRING` // must be either `asc` or `desc`

For example, these two calls will return the 60 most recent log
messages, in batches of 30, sorted by creation date:

    GET /messages?perPage=30&page=0&key=createdOn&order=asc
    GET /messages?perPage=30&page=1&key=createdOn&order=asc

# Response Payloads

For success responses (`200` or `201`) from `GET`, `POST`, or `PUT`, the
JSON object returned will be:

    {
        // required
        data: OBJECT
        type: STRING

        // used only if data is a map or an array
        pagination: {
            // all fields required
            count: INT
            page: INT
            perPage: INT
            sortBy: STRING
            order: STRING    // must be either "asc" or "desc"
        }

        // optional, for information about the request itself
        metadata: OBJECT
    }

The `type` field is a string that indicates the structure of the object
in `data`. The valid strings are documented with the APIs.

For error responses (`4xx` or `5xx`), the response is:

    {
        // required
        message: string

        // any other fields allowed as needed, based on nature of error, such as:
        origin: string
        metadata: // opt
        stackTrace: // opt
        jobId: // opt
        frobNitz: // opt
    }

Note that `DELETE` requests will return a `200` and a success payload
which may be empty.

# HTTP Status Codes

We generally only use these HTTP status codes.

`200 OK`  
The request has succeeded. The information returned with the response is
dependent on the method used in the request. For `GET`, the response is
an entity containing the requested resource. For `POST`, it is entity
containing the result of the action.

`201 Created`  
The request has been fulfilled and resulted in a new resource being
created. The newly created resource can be referenced by the URI(s)
returned in the entity of the response. The origin server MUST create
the resource before returning the 201 status code.

`400 Bad Request`  
The request could not be understood by the server due to malformed
syntax.

`401 Unauthorized`  
The request requires user authentication, e.g. due to missing or invalid
authentication token.

`403 Forbidden`  
The server understood the request, but is refusing to fulfill it and
retrying with different authorization will not help. For example, use
`403` when a resource does not support the requested operation, e.g.
`PUT`. `403` may also be used in cases where user is not authorized to
perform the operation or the resource is unavailable for some reason
(e.g. time constraints, etc.).

`404 Not Found`  
The requested resource could not be found but may be available again in
the future. Subsequent requests by the client are permissible.

`500 Internal Server Error`  
The server encountered an unexpected condition which prevented it from
fulfilling the request.

# Operations (Verbs)

By default, all resources should support GET, POST, PUT, DELETE. If a
verb not valid for a resource type, `403` should be returned.

Remember, `POST` is for creating a resource and `PUT` is for updating a
resource.

`GET`  
returns `200` with a response payload containing the requested object,
or an array or map of objects

`POST`  
returns `201` with a response payload containing the created object

`PUT`  
returns `200` with a response payload containing the updated object

`DELETE`  
returns `200` with a response payload whose `data` field is set to `{}`

# URLs

Use `lowerCamelCase` in URLs and query parameters if needed to match the
JSON field names. For example:

    GET /eventType?sortBy=eventTypeId   // YES!
    GET /eventtype?sortby=eventtypeid   // NO!

# Common Endpoints

`GET /`  
requests a "health check" for the service. The returned status code is
`200` with a response payload containing a short, friendly text string.

`GET /admin/stats`  
requests the current metrics for the service. The returned payload will
contain an object with the metric data. Such data might include things
like the time the service started, how many requests it has served, etc.
