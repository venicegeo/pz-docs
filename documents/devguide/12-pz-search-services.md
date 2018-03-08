# Pz Search Services

The Piazza Core Search infrastructure includes two services with REST APIs:

1. [pz-search-metadata-ingest](https://github.com/venicegeo/pz-search-metadata-ingest)
	
	Service to accept a JSON structure for metadata ingest to the Piazza Elasticsearch cluster

2. [pz-search-query](https://github.com/venicegeo/pz-search-query). 
	
	Service that accepts queries to Piazza Elasticsearch instance for content discovery endpoints, accepting an HTTP POST of Elasticsearch query language (DSL).

As spatial data is loaded into Piazza, metadata is extracted and indexed by the Search component. When user services are registered, the metadata about the services is also are extracted and indexed. Once the metadata is indexed, NPEs can then submit queries to the Gateway to discover resources in the Elasticsearch metadata catalog.

## Building Running Locally

Please refer to repository README:

[pz-search-metadata-ingest README](https://github.com/venicegeo/pz-search-metadata-ingest)

[pz-search-query README](https://github.com/venicegeo/pz-search-query)
