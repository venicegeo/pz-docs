# Workflow Service

# Overview 
The Workflow service enables the construction and use of "event" notifications to enable simple "if-this-happens-then-do-that" workflows. This is done though an HTTP API. 

For a walkthough visit the Users Guide, for a simple overview visit [pz-swagger](https://pz-swagger.geointservices.io//Workflow).

A user will follow these general steps:

1.  Register a new event type

2.  Register a trigger for that event type

3.  Send an event

4.  Poll for new alerts

5.  Go to 3.

## Building and Running Locally 
To find out how to run the pz-workflow service locally, please visit the github [README](https://github.com/venicegeo/pz-workflow/blob/readme-updates/README.md)

## Technical

### Elasticsearch Interaction
[Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
is the chosen database for the workflow service. Elasticsearch can be
defined as a *nosql* using Lucene query. This can provide powerful query
ability but at the cost of some inconveniences interacting with the
database. When running locally workflow will automatically attach to a
local elasticsearch instance, but when using an offsite elasticsearch
addition information must be provided in the VCAP services. Workflow has
been designed in a way to reduce elasticsearch’s *nosql* capabilites.
This is done by creating strict mapping types on all schemas. This
insures that elasticsearch will only accept documents that exactly match
the specified schema. Workflow uses two packages in order to communicate
with elasticsearch. The first of these is [pz-gocommon index
file](https://github.com/venicegeo/pz-gocommon/blob/master/elasticsearch/index.go).
This allows workflow to create simple communication with an index. This
index file itself relies on
[elastic.v3](http://gopkg.in/olivere/elastic.v3) to create the HTTP
traffic.

### Kafka Interaction 
Information on Kafka can be found [here](https://kafka.apache.org/intro). In workflow, Kafka service information must be provided in the VCAP services. After an event *triggers* a trigger, a job is sent to kafka. The function for this can be found [here](https://github.com/venicegeo/pz-workflow/blob/ff8b869893f910145d5205ed2557f22ca0e1da24/workflow/Service.go#L206). Often when running workflow locally VCAP services are not provided, therefore no connection with kafka can be made, making jobs fail to be sent. A way of testing whether or not triggers work is checking to see if a kafka error was created in the workflow process terminal.

### Other Required Services 
pz-workflow also requires two other services: pz-idam & pz-servicecontroller. These do not require the use of VCAP as they are part of the piazza system. Workflow will only fail to launch if it cannot contact the piazza system. Service controller is used in workflow to validate service uuids when creating a trigger. Found [here](https://github.com/venicegeo/pz-workflow/blob/3864890c012854223569212af85d36eb077d1725/workflow/TriggerDB.go#L54). Idam is used when a trigger is attempting to fire off a job, which idam can allow or deny. Found [here](https://github.com/venicegeo/pz-workflow/blob/ac6a9287aea9e9ec24a83a38e1b19895a14df730/workflow/Service.go#L782), however notice that the actual auth function is contained in [pz-gocommon](https://github.com/venicegeo/pz-gocommon/blob/master/gocommon/authz.go).

### Programmatic Hierarchy 
The workflow service has three distinct hierarchical sections: `Server`, `Service`, `DB`. The Server is the top layer. This is where HTTP requests are forwarded two. The job of the `Server` functions is to call the correct function in the `Service` and return a valid json response. The `Service` contains the bulk of the operation. There are functions designed for support, such as `sendToKafka` or `newIdent`, and functions that mirror those in the `Server`. These functions perform the logic of whichever rest call was made, interacting with `DB`'s to do so. The `DB`'s interact with the index mentioned in the elasticsearch interaction section. The role of these functions is to provide higher level functions when communicating with elasticsearch, such as queries.

### Notes

Unique parameter types for different event types For example, there are two event types. Event type `A` has variable `foo` type `string`. Now a different user wants to create an event type `B` that also has the variable `foo` but wants it to be type `float`. Using elasticsearch as is, this would not be possible. When creating a mapping, each variable and its type gets stored in elasticsearch, and there cannot be multiple types of the same variable. Knowing that each event type name must be unique, this is a simple problem to combat. Instead, the variables can simply be renamed, using dot notation, to `A.foo` type `string` and `B.foo` type `float`. This can be done when creating and event type and storing in elasticsearch, and when the event type is being retrieved it can simply be removed. This can all be done without the user being aware. The encoding is done [here](https://github.com/venicegeo/pz-workflow/blob/ac6a9287aea9e9ec24a83a38e1b19895a14df730/workflow/Service.go#L470), the decoding is done [here](https://github.com/venicegeo/pz-workflow/blob/ac6a9287aea9e9ec24a83a38e1b19895a14df730/workflow/Service.go#L330) and the called functions are as simple as this: 


	func (service *Service) addUniqueParams(uniqueKey string, inputObj map[string]interface{}) map\[string\]interface{} 
	{ 
		outputObj := map[string]interface{}{} 
		outputObj[uniqueKey] = inputObj 
		return outputObj 
	} 
	
	func (service *Service) removeUniqueParams(uniqueKey string, inputObj map[string]interface{}) map[string]interface{} 
	{ 
		if _, ok := inputObj[uniqueKey]; !ok 
		{ 
			return inputObj 
		} 
		return inputObj[uniqueKey].(map[string]interface{})
	}


This in turn also effects trigger queries as the variables users are trying to query have had there names changed. This is accounted for [here](https://github.com/venicegeo/pz-workflow/blob/ac6a9287aea9e9ec24a83a38e1b19895a14df730/workflow/TriggerDB.go#L375) and the following functions.

### Event index version number 

When creating a trigger, workflow creates a [percolator query](https://www.elastic.co/guide/en/elasticsearch/reference/2.0/search-percolate.html) in the events index. For simplicity, workflow allows percolator queries to contain dot notation for terms. This can only be done by tricking an index into thinking it is an index from elasticsearch 2.0, as this was the last time dot notation was permitted in percolator queries. This is done [here](https://github.com/venicegeo/pz-workflow/blob/ac6a9287aea9e9ec24a83a38e1b19895a14df730/db/000-Event.sh#L41).
