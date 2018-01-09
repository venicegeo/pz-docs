\#\# Prerequisites for Using Piazza

To build and run Piazza, the table below depicts the software that is
needed. As a convenience, Piazza provides Vagrant boxes for the required
backing services.

<table>
<caption>Piazza Software Prerequisites</caption>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>Software Item</p></td>
<td><p>Description</p></td>
<td><p>Backing Service</p></td>
</tr>
<tr class="even">
<td><p>Java Development Kit 1.8</p></td>
<td><p>Compiler for building the following Piazza components: Access, Gateway, Ingest, IDAM, JobCommon, JobManager and ServiceController</p></td>
<td><p>No</p></td>
</tr>
<tr class="odd">
<td><p>Go 1.7.x</p></td>
<td><p>Compiler for building the following Piazza components: Logger and Workflow</p></td>
<td><p>No</p></td>
</tr>
<tr class="even">
<td><p>Maven 3.3.9</p></td>
<td><p>Build infrastructure for building Java applications</p></td>
<td><p>No</p></td>
</tr>
<tr class="odd">
<td><p>Oracle VM VirtualBox 5.0.10</p></td>
<td><p>Virtual Machine infrastructure for running individual backing services</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="even">
<td><p>MongoDB 2.6.3</p></td>
<td><p>Database supporting Java micro services</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="odd">
<td><p>GeoServer 2.9.2</p></td>
<td><p>Server for providing geospatial image support using Open Geospatial Consortium (OGC) standards</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="even">
<td><p>PostgreSQL (Crunchy) 9.5.2</p></td>
<td><p>Database used to support storing and retrieving of loaded geospatial data</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="odd">
<td><p>Apache Kafka 0.9.0.1</p></td>
<td><p>Messaging Bus used for asynchronous message support.</p></td>
<td><p>Yes</p></td>
</tr>
</tbody>
</table>

<table>
<caption>Local Vagrant Boxes available for Services</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>Vagrant Box</p></td>
<td>Location</td>
</tr>
<tr class="even">
<td><p>ElasticSearch</p></td>
<td><a href="https://github.com/venicegeo/pz-search-metadata-ingest/tree/master/config" class="uri">https://github.com/venicegeo/pz-search-metadata-ingest/tree/master/config</a></td>
</tr>
<tr class="odd">
<td><p>MongoDB</p></td>
<td><a href="https://github.com/venicegeo/pz-jobmanager/tree/master/config" class="uri">https://github.com/venicegeo/pz-jobmanager/tree/master/config</a></td>
</tr>
<tr class="even">
<td><p>GeoServer</p></td>
<td><a href="https://github.com/venicegeo/pz-access/tree/master/config" class="uri">https://github.com/venicegeo/pz-access/tree/master/config</a></td>
</tr>
<tr class="odd">
<td><p>PostgreSQL</p></td>
<td><a href="https://github.com/venicegeo/pz-ingest/tree/master/config" class="uri">https://github.com/venicegeo/pz-ingest/tree/master/config</a></td>
</tr>
<tr class="even">
<td><p>Apache Kafka</p></td>
<td><a href="https://github.com/venicegeo/kafka-devbox" class="uri">https://github.com/venicegeo/kafka-devbox</a></td>
</tr>
</tbody>
</table>

\#\# Accessing Piazza

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

For details on the Gateway API, see [Swagger
Documentation](https://pz-swagger.geointservices.io/) for details on
each of the endpoints.

For details on how to use case scenarios, see the [Piazza Users
Guide](https://pz-docs.geointservices.io/userguide/index.html).

For details on the code for the Gateway, see the [???](#Gateway) section
for details.
