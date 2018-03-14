# Prerequisites for Using Piazza

To build and run Piazza, the table below depicts the software that is needed. As a convenience, Piazza provides Vagrant boxes for the required backing services.

## Piazza Software Prerequisites

The table below outlines the prerequisites for building/compiling piazza software, and getting piazza up and running in an environment. 

<table class="table piazza-sw-prereqs">
    <thead>
        <tr>
            <th>Software Item</th>
            <th>Version</th>
            <th>Description</th>
            <th>Backing Service</th>
        </tr>
    </thead>
    <tbody>
        <tr class="odd">
            <td>Java Development Kit</td>
            <td>1.8</td>
            <td>Compiler for building the following Piazza components: Access, Gateway, Ingest, IDAM, JobCommon, JobManager and ServiceController</td>
            <td>No</td>
        </tr>
        <tr class="even">
            <td>Go</td>
            <td>1.7.x</td>
            <td>Compiler for building the following Piazza components: Logger and Workflow</td>
            <td>No</td>
        </tr>
        <tr class="odd">
            <td>Maven</td>
            <td>3.3.9</td>
            <td>Build infrastructure for building Java applications</td>
            <td>No</td>
        </tr>
        <tr class="even">
            <td>Oracle VM VirtualBox</td>
            <td>5.0.10</td>
            <td>Virtual Machine infrastructure for running individual backing services</td>
            <td>Yes</td>
        </tr>
        <tr class="odd">
            <td>MongoDB</td>
            <td>2.6.3</td>
            <td>Database supporting Java micro services</td>
            <td>Yes</td>
        </tr>
        <tr class="even">
            <td>GeoServer</td>
            <td>2.9.2</td>
            <td>Server for providing geospatial image support using Open Geospatial Consortium (OGC) standards</td>
            <td>Yes</td>
        </tr>
        <tr class="odd">
            <td>PostgreSQL (Crunchy)</td>
            <td>9.5.2</td>
            <td>Database used to support storing and retrieving of loaded geospatial data</td>
            <td>Yes</td>
        </tr>
        <tr class="even">
            <td>Apache Kafka</td>
            <td>0.9.0.1</td>
            <td>Messaging Bus used for asynchronous message support.</td>
            <td>Yes</td>
        </tr>
    </tbody>
</table>

### Local Vagrant Boxes available for Services
<table class="table">
    <thead>
        <tr>
            <th>Vagrant Box</th>
            <th>Location</th>
        </tr>
    </thead>
    <tbody>
		<tr class="odd">
			<td>ElasticSearch</td>
			<td>
				<a target="_blank" class="uri" 
					href="https://github.com/venicegeo/pz-search-metadata-ingest/tree/master/config">https://github.com/venicegeo/pz-search-metadata-ingest/tree/master/config</a>
			</td>
        </tr>
        <tr class="even">
            <td>MongoDB</td>
            <td>
            		<a target="_blank" class="uri" 
            			href="https://github.com/venicegeo/pz-jobmanager/tree/master/config">https://github.com/venicegeo/pz-jobmanager/tree/master/config</a>
            	</td>
        </tr>
        <tr class="odd">
            <td>GeoServer</td>
            <td>
            		<a target="_blank" class="uri" 
            			href="https://github.com/venicegeo/pz-access/tree/master/config">https://github.com/venicegeo/pz-access/tree/master/config</a>
            </td>
        </tr>
        <tr class="even">
            <td>PostgreSQL</td>
            <td>
            		<a target="_blank" class="uri" 
            			href="https://github.com/venicegeo/pz-ingest/tree/master/config">https://github.com/venicegeo/pz-ingest/tree/master/config</a>
            	</td>
        </tr>
        <tr class="odd">
            <td>Apache Kafka</td>
            <td>
            		<a target="_blank" class="uri" 
            			href="https://github.com/venicegeo/kafka-devbox">https://github.com/venicegeo/kafka-devbox</a>
            	</td>
        </tr>
    </tbody>
</table>

## Accessing Piazza

Using Piazza, NPEs can perform actions such as the loading and retrieval
data, the registration and execution user services, and registration of
workflow events or triggers. The requests and responses from the Gateway
are defined via JSON. The Gateway acts as an external broker, or proxy,
to the internal components of the Piazza application. The Gateway will
receive user requests, and then route that request or command to the
appropriate internal Piazza component.

The Gateway is the single point-of-contact for external users to
interact with Piazza Core components. This API provides functionality
for loading and accessing data, registering and executing services, and
registering events and triggers. The entirety of Piazza functionality is
accessed through these Gateway API calls.

For details on the Gateway API, see <a target="_blank" href="https://pz-swagger.geointservices.io/">Swagger Documentation</a> for details on each of the endpoints.

For details on how to use case scenarios, see the <a target="_blank" href="/userguide/index.html">Piazza Users Guide</a>.

For details on the code for the Gateway, see the <a target="_blank" href="index.html#gateway">Gateway</a> section for details.
