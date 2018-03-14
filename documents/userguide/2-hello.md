# Hello, Piazza!

In this section, we will work through the steps to make your first Piazza service call.

## Setup

Prior to using the Piazza API, you need to have an API key and two environment variables set properly.

### Setting `$PZSERVER`

The `$PZSERVER` environment variable needs to be set to the host name of your Piazza instance. Typically this will look something like:

    $ export PZSERVER=piazza.venicegeo.io

### Generating Your API Key

For secure access to Piazza, each HTTP request must include an API key specific to your account. Assuming you have already set `$PZSERVER` in the previous section, you can generate a key from the command line:

    $ curl -u USERNAME:PASSWORD https://$PZSERVER/key

where `USERNAME` and `PASSWORD` are your actual username and password. (You may need to put double-quotes around the password if it contains "special" characters.)

The JSON response you get back will look similar to this:

    {
        "type" : "uuid",
        "uuid" : "45a1ba5d-cd7b-4c83-bd81-2fa2a03817d4"
    }

The `uuid` value, `"45a1..."`, is your new key.

### Setting `$PZKEY`

You can now set the `$PZKEY` environment variable to your new key, the `uuid` value:

    $ export PZKEY=45a1ba5d-cd7b-4c83-bd81-2fa2a03817d4

As a convenience, if `$PZKEY` is not set, the example scripts look in the file `$HOME/.pzkey` for the key for your server. The `.pzkey` file contains just a JSON map from server names to keys:

    {
        "piazza.venicegeo.io": "45a1ba5d-cd7b-4c83-bd81-2fa2a03817d4",
        "piazza.pizza4all.com": "2525ad6a-aae9-41f0-9caf-c21b8fa4d7d2"
    }

If you have `$PZSERVER` set to `piazza.venicegeo.io`, the scripts will set `$PZKEY` to the key `"45a1..."` to use for that Piazza instance.

## Some Notes About the Examples

The code examples in this guide are presented as shell scripts that use `curl` for the HTTP calls and JSON for the request and response payloads. To simplify the examples, the scripts rely on a setup script, helpfully named <a target="_blank" href="scripts/setup.sh">setup.sh</a>, that will verify you have `$PZSERVER` and `$PZKEY` (or a `$HOME/.pzkey` file) set correctly. It will also define some helpful aliases and functions to make the examples shorter, such as pre-setting some required options for `curl`.

Some of the example scripts require one or more input arguments. These are expected to be provided on the command-line as simple strings. The scripts will verify that the right number of arguments were provided.

The example scripts generally produce output. In most cases, the output will be a JSON object to `stdout`.

As an extra aid for both learning and testing, the script <a target="_blank" href="scripts/runall.sh">runall.sh</a> is provided. This script runs each of the example scripts in order, passing the outputs from one to the inputs of the next, and verifying those outputs are correct. (To use `runall.sh`, you must have the wonderful tool <a target="_blank" href="https://stedolan.github.io/jq/">jq</a> installed.)

## Hello!

With the setup work completed, we are now able to run a simple "health check" ping to verify that we have a functioning instance of Piazza to talk to. We do this by sending an HTTP `GET` request to the server’s root endpoint, `/`.

<a target="_blank" href="scripts/hello.sh">hello.sh</a>

    #!/bin/bash

    set -e

    . setup.sh

    $curl -X GET $PZSERVER

Note the line invoking `setup.sh`, mentioned above, and other nonessential lines. In subsequent listings in this document, we will omit those sorts of lines and only show the "important" commands. The full script, however, is always available by following the download link.

You can run this script simply as:

    $ ./hello.sh

and it should return a message similar to this:

    Hello, Health Check here for pz-gateway.

> **Note**
>
> You should verify that the health check script works correctly before continuing with this tutorial. If it does not work, make sure you have the right server name, a valid API key, and correctly set `$PZSERVER` and `$PZKEY` environment variables.

> **Note**
>
> For the remainder of this document, we will use `venicegeo.io` in embedded links. You will need to resolve the proper path manually for your site installation.

## Other Helpful Tools

As you work through this tutorial, you might find these two additional Piazza resources helpful:

-   `pz-swagger` is a browser-based UI for exploring Piazza’s REST API. It is located at the same parent address as your `piazza` host, e.g., `pz-swagger.venicegeo.io`. If you are not familiar with Swagger, see <a target="_blank" href="http://swagger.io">swagger.io</a>.

-   `pz-sak` is a developer-level tool for directly interacting with some of Piazza’s public and private services. For example, you can use SAK to examine log files, check the status of jobs, and perform metadata queries. It too can be found under the same parent host address, e.g., `pz-sak.venicegeo.io`. SAK is a tool for debugging and testing only; it is not to be used in production. Contact the Piazza team for assistance with SAK.
