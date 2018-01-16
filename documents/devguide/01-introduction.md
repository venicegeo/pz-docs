# Introduction The Piazza API is a series of REST endpoints that allow
Non Person Entities (NPEs) to access tools and interact with all of
Piazza’s core functionality. All NPE requests come into Piazza through
an entry-point called the Gateway. The Gateway is an abstract layer to
Piazza which hides the core services so NPEs can communicate with Piazza
using a single service endpoint. This architecture approach allows for
changes within Piazza to happen without affecting the NPEs.

Piazza leverages a number of backing services to enable the rapid
development of enterprise GIS solutions. The figure below shows a high
level overview of the interactions between Piazza and these backing
services.

All Piazza requests are authenticated with an API Key associated with
each request’s basic authentication headers. This API Key is generated
and held by Piazza’s Identity and Access Management (IDAM) component.

![Piazza High Level Architecture Diagram](images/pz-hla-diagram.jpg)

Developers have access to Piazza’s API documentation (Swagger) and
User’s Guide (Docs) to learn how to use Piazza’s REST API to implement
GEOINT solutions to support the mission. To review these items refer to
the References section for details.

To verify and administer Piazza’s capability, Piazza’s Swiss Army Knife
(SAK) web application provides Piazza administrators with dashboard view
into the Piazza system. Using this dashboard, administrators can verify
the operational capabilities of various Piazza microservices.

Piazza leverages MongoDB for system support, Elasticsearch for
searching/indexing support and Crunchy PostgreSQL/PostGIS for processing
support of geospatial data. For activities that are time intensive and
to support internal microservice communication, Piazza uses Apache Kafka
for asynchronous messaging support. To provide access to enterprise
storage, Piazza leverages Amazon’s Simple Storage Service (S3) for
loading/accessing data processing results and geospatial data. NPEs can
also access geospatial data by using OGC standard APIs (Boundless
GeoServer).
