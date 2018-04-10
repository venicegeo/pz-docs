# Search

Piazza supports searching across the metadata extracted from all loaded data. The search API returns the Resource IDs of any matching items.

Two kinds of searching are supported. First, when doing a `GET` on the `/data` endpoint, you specify the keyword to be matched; the list normally returned by a `GET` is filtered to contain just those resources that match the keyword. This is called a *filtered* GET. Second, when doing a `POST` to the `/data/query` endpoint, you provide an Elasticsearch JSON object. Piazza uses the <a target="_blank" href="https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html">Elasticsearch DSL</a> directly (instead of inventing yet another query syntax language).

Note that adding data to the search index is an internal Piazza function and therefore does not have an API.

## Setup

To demonstrate, we will first load three files into Piazza and set the metadata fields with some interesting strings. (We will use the same source <a target="_blank" href="scripts/terrametrics.tif">GeoTIFF</a> since we only care about the metadata.) And to do that, we need a script that loads the file with a given name and description and returns the corresponding data Resource ID. Fortunately, we wrote this script already, <a target="_blank" href="scripts/post-hosted-load.sh">post-hosted-load.sh</a>. We will call it three times.

<a target="_blank" href="scripts/load-files.sh">load-files.sh</a>

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

## Filtered `GET` Example

Now that we have the files loaded, we will perform a filtered `GET`. This script takes one argument: the keyword to search for. The server will return a response with the metadata objects that matched the keyword.

<a target="_blank" href="scripts/search-filter.sh">search-filter.sh</a>

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

## Query Example

We can perform a more advanced query on data with a `POST` request to the `/data/query` endpoint, with the post body containing the JSON query object.

<a target="_blank" href="scripts/search-query.sh">search-query.sh</a>

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

Visit the <a target="_blank" href="index.html#elasticsearch_query_syntax">Elasticsearch Query Syntax</a> section for more details on the Elasticsearch DSL.

## Search API Documentation

See <a target="_blank" href="http://pz-swagger.venicegeo.io/#/Search">http://pz-swagger.venicegeo.io/#/Search</a>
