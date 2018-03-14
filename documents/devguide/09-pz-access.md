# Access

The Access component is what handles the accessing of this data - either by requesting metadata, requesting file downloads, or requesting GeoServer deployments of data. When requesting GeoServer deployments of loaded data into Piazza, the Access component will transfer the appropriate files over to the GeoServer data directory, and then create a deployment lease that provides a guarantee for a certain length of time that the data will be available on the Piazza GeoServer instance.

## Building and Running Locally

Please refer to repository <a target="_blank" href="https://github.com/venicegeo/pz-access">README</a>

## S3 Credentials

The Access component deploys files uploaded to S3 by the Gateway. 

These values are referenced in the ENV variables:

	vcap.services.pz-blobstore.credentials.access_key_id
	vcap.services.pz-blobstore.credentials.secret_access_key 

If you are a developer and you do not have these values on your host, you will not be able to deploy files to GeoServer using a local debug instance.

## Source Organization

The main logic of the Access component is split between two packages:

1. Controller

	The <a target="_blank" href="https://github.com/venicegeo/pz-access/tree/master/src/main/java/access/controller">`controller`</a> package contains the Spring RestController class that defines REST endpoints that handle user queries for DataResource information, and other REST endpoints used.

2. Messaging

	The <a target="_blank" href="https://github.com/venicegeo/pz-access/tree/master/src/main/java/access/messaging">`messaging`</a> package defines Kafka consumers which listen for messages through Kafka for creating GeoServer deployments. The logic for the deploying of data resources as GeoServer layers happens in the <a target="_blank" href="https://github.com/venicegeo/pz-access/tree/master/src/main/java/access/deploy">`deploy`</a> package through the <a target="_blank" href="https://github.com/venicegeo/pz-access/blob/master/src/main/java/access/deploy/Deployer.java">`Deployer`</a> and <a target="_blank" href="https://github.com/venicegeo/pz-access/blob/master/src/main/java/access/deploy/Leaser.java">`Leaser`</a> classes. These two classes manage the deployments of GeoServer (Deployment.java), and managing their life 	times and resource cleanup <a target="_blank" href="https://github.com/venicegeo/pz-access/blob/master/src/main/java/access/deploy/Leaser.java">`Leaser`</a>. In the <a target="_blank" href="https://github.com/venicegeo/pz-access/blob/master/src/main/java/access/deploy/Leaser.java">`Leaser`</a> class, there is a method <a target="_blank" href="https://github.com/venicegeo/pz-access/blob/master/src/main/java/access/deploy/Leaser.java#L136">`reapExpiredLeases()`</a> that runs once a night that will clean up any expired resources on GeoServer.

The Access component interacts with the MongoDB DataResource collection, and management for this code is located in the
<a target="_blank" href="https://github.com/venicegeo/pz-access/tree/master/src/main/java/access/database">`database()`</a> package.

## Interface

For users requesting deployments, the Access service listens to Kafka messages. The interfaces allow users to request Deployments of data currently loaded into Piazza, or more simply to just query the Data that is currently ingested into Piazza. Access also handles some Gateway API Endpoint requests based on the `/data` endpoint, which are used for retrieving geospatial metadata or other information related to loaded Piazza data.

# Querying Metadata

After processing a Job through the `Loader` component, a Data Resource will be added to the Piazza system. The Access component provides a Gateway API Endpoint Job which will allow users to query the metadata for the data that has been ingested into Piazza.

    /data/{dataId}

The response for this request will be all of the metadata currently held in Piazza for this Resource:

    {
        "dataId": "03810dc8-82a8-4cbc-95c1-75699142f95c",
        "dataType": {
            "content": "This text itself is the raw data to be ingested. In reality, it could be some GML, or GeoJSON, or whatever.",
            "mimeType": "application/text",
            "type": "text"
        },
        "metadata": {
            "classType": {
                "classification": "unclassified"
            },
            "description": "This is a test.",
            "name": "Testing some Text Input"
        }
    }

The `dataId` field is the unique ID for this dataset. The `dataType` field describes all information required for describing the type of file, format, and location of the data. The `spatialMetadata` will include information such as Bounding Box and Coordinate Reference System. The `metadata` field will contain other metadata information such as `contact` or `classification`.

## Accessing Data

Currently, there are two ways to get data out of Piazza. The first is retrieving the raw file that was initially ingested. The second is to get a live GeoServer deployment of the ingested data.

# File Access

This will simply retrieve the file for a Resource item. The Gateway API Endpoint is:

    /data/file/{dataId}

The response for this request will be the actual bytes of the file.

# Deployments

## GeoServer Deployments

A better way to Access data, instead of accessing the raw file, is to have Piazza stand up a GeoServer service that can be used to access vector data as Web Feature Services (WFS) or raster data as Web Coverage Services (WCS). This is handled by POSTing to the `/deployment` Gateway API endpoint.

    POST /deployment

    {
        "type": "access",
        "dataId": "d42bfc70-0194-47bb-bb70-a16346eff42b",
        "deploymentType": "geoserver"
    }

### Deployment Leases

A Lease represents an amount of time that a deployed resource is available in the system for. Deployments should be guaranteed to be available as long as they have an active Deployment lease. A Lease is considered active as long as its expiration date has not passed. If the expiration date of a lease has passed, then the resource may still be available (perhaps it has not been subject to resource reaping yet) but it will not be guaranteed. Periodically expired leases will be undeployed in order to avoid overtaxing the system with outdated or unused deployments.

## Supported Data Types

The table below shows the different data types, as well as if there is access and hosted or not hosted.

<table class="table">
	<thead>
		<tr>
			<th>Data Type</th>
			<th>Access and Hosted</th>
			<th>Access and Not Hosted</th>
		</tr>
	</thead>
	<tbody>
		<tr class="odd">
			<td>Text</td>
			<td>Yes, direct text</td>
			<td>Not Applicable</td>
		</tr>
		<tr class="even">
			<td>Shapefile</td>
			<td>Yes, GeoServer</td>
			<td>Not Possible</td>
		</tr>
		<tr class="odd">
			<td>GeoTIFF</td>
			<td>Yes, GeoServer</td>
			<td>Not Possible</td>
		</tr>
		<tr class="even">
			<td>PointCloud</td>
			<td>Yes, GeoServer</td>
			<td>Not Possible</td>
		</tr>
		<tr class="odd">
			<td>Web Feature Service</td>
			<td>Yes, GeoServer</td>
			<td>Yes, via the external URL</td>
		</tr>
		<tr class="even">
			<td>GeoJSON</td>
			<td>Yes, GeoServer</td>
			<td>Not Possible</td>
		</tr>
	</tbody>
</table>

## Administrative API

The Access component provides a series of REST Endpoints that can be used to query the Data held by Piazza. This is provided for certain information useful to utilities like the Swiss-Army-Knife (SAK). It provides nothing more than a debug look into the system. These endpoints would most likely be locked down in production. 

The requests are as follows:

### REST Endpoints

#### Data Count
`/data/count`  

Gets a count of the Resources held in the Piazza system.

### Administrative Statistics
`GET /admin/stats`

Return object containing information regarding the running instance of this component. This will return the list of Job IDs of currently processing Jobs owned by this component.

    {
        "jobs": ["job-id-1", "job-id-2"]
    }
