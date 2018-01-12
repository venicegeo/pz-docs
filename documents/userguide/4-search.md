\# Search

Piazza supports searching across the metadata extracted from all loaded
data. The search API returns the Resource IDs of any matching items.

Two kinds of searching are supported. First, when doing a `GET` on the
`/data` endpoint, you specify the keyword to be matched; the list
normally returned by a `GET` is filtered to contain just those resources
that match the keyword. This is called a *filtered* GET. Second, when
doing a `POST` to the `/data/query` endpoint, you provide an
Elasticsearch JSON object. Piazza uses the [Elasticsearch
DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html)
directly (instead of inventing yet another query syntax language).

Note that adding data to the search index is an internal Piazza function
and therefore does not have an API.

\#\# Setup

To demonstrate, we will first load three files into Piazza and set the
metadata fields with some interesting strings. (We will use the same
source [GeoTIFF](scripts/terrametrics.tif) since we only care about the
metadata.) And to do that, we need a script that loads the file with a
given name and description and returns the corresponding data Resource
ID. Fortunately, we wrote this script already,
[post-hosted-load.sh](scripts/post-hosted-load.sh). We will call it
three times.

[load-files.sh](scripts/load-files.sh)

    #!/bin/bash
    set -e
    . setup.sh

    # tag::public[]
    a="one"
    b="The quick, brown fox."
    one=`./post-hosted-load.sh "$a" "$b"`
    echo "$one"

    a="two"
    b="The lazy dog."
    two=`./post-hosted-load.sh "$a" "$b"`
    echo "$two"

    a="three"
    b="The hungry hungry hippo."
    three=`./post-hosted-load.sh "$a" "$b"`
    echo "$three"
    # end::public[]

This will return the information about three load operations:

    $ ./load-files.sh

\#\# Filtered `GET` Example

Now that we have the files loaded, we will perform a filtered `GET`.
This script takes one argument: the keyword to search for. The server
will return a response with the metadata objects that matched the
keyword.

[search-filter.sh](scripts/search-filter.sh)

    #!/bin/bash
    set -e
    . setup.sh

    check_arg $1 term

    # tag::public[]
    term=$1

    $curl -X GET $PZSERVER/data?keyword=$term
    # end::public[]

Execute this script by passing in the keyword:

    $ ./search-filter.sh "dog"

\#\# Query Example

We can perform a more advanced query on data with a `POST` request to
the `/data/query` endpoint, with the post body containing the JSON query
object.

[search-query.sh](scripts/search-query.sh)

    #!/bin/bash
    set -e
    . setup.sh

    check_arg $1 term

    # tag::public[]
    term=$1

    query='{
        "query": {
            "match": { "_all": "'"$term"'" }
        }
    }'

    $curl -X POST -d "$query" $PZSERVER/data/query?perPage=100&page=0
    # end::public[]

To execute:

    $ ./search-query.sh "kitten"

Visit the [???](#Elasticsearch Query Syntax) section for more details on
the Elasticsearch DSL.

\#\# Search API Documentation

See <http://pz-swagger.venicegeo.io/#/Search>
