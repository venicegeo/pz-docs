# Ingest

The Ingest component is the internal component that handles the loading of spatial data. This component is capable of referencing data held in external locations, such as another accessible S3 file store; or loading data specified by the user to be stored directly within Piazza. The Ingest component receives Kafka messages from the Gateway, with the information as to the file to be stored. It then inspects the data to validate and populate metadata fields (such as Area of Interest) and
then stores this metadata within the Piazza MongoDB instance.

## Building Running Locally

Please refer to repository <a target="_blank" href="https://github.com/venicegeo/pz-ingest">README</a>

## S3 Credentials

The Ingest component inspects files uploaded to S3 by the Gateway. As such, the `pz-ingest` component is also dependent on the following ENV variables:

	vcap.services.pz-blobstore.credentials.access_key_id
	vcap.services.pz-blobstore.credentials.secret_access_key

## Source Organization

The <a target="_blank" href="https://github.com/venicegeo/pz-ingest/tree/master/src/main/java/ingest/messaging">messaging</a> package in source contains the classes that handle the incoming Kafka messages, which contain the information regarding the data to be ingested. The <a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/messaging/IngestWorker.java">`IngestWorker`</a> class contains the majority of this logic. When new data is ingested, the data information is passed onto inspectors located in the <a target="_blank" href="https://github.com/venicegeo/pz-ingest/tree/master/src/main/java/ingest/inspect">`inspect`</a> package. There is an inspector for each type of data (
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/GeoJsonInspector">GeoJSON</a>, 
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/GeoTiffInspector.java">GeoTIFF</a>, 
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/PointCloudInspector.java">Point Cloud</a>, 
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/ShapefileInspector.java">Shapefile</a>, 
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/TextInspector.java">Text</a>, 
<a target="_blank" href="https://github.com/venicegeo/pz-ingest/blob/master/src/main/java/ingest/inspect/WfsInspector.java">WFS</a>). These inspectors will dig into the data to validate and parse out any relevant metadata. The inspectors are what will create the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/data/DataResource.java">'DataResource'</a> objects and store them into the MongoDB instance.

The <a target="_blank" href="https://github.com/venicegeo/pz-ingest/tree/master/src/main/java/ingest/controller">controller</a> package contains the administrative REST endpoints for this component.

## Interface

In order to Load data, a message will be posted to the Gateway to create an Load job. There are two Gateway API endpoints to load data.

    POST /data

This first endpoint takes in a JSON payload only. This is used when a file does not need to specified - and instead, an S3 path or public folder share location is used to load the data.

    GET /data/file

This second endpoint is a multi-part POST request which takes in an actual geospatial file and loads this into Piazza data holdings.

The JSON payload for either of the above endpoints will look like:

    {
        "type": "ingest",
        "host": true,
        "data" : {
            // Description of the Data Here
        },
        "metadata": {}
    }

The metadata fields under the `jobType.data` tag are defined in the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/data/DataResource.java">DataResource</a> POJO object. This object contains the <a target="_blank" href="https://github.com/venicegeo/pz-wps/blob/master/pizza_wps_2_0/src/main/java/org/w3/_1999/xlink/ResourceType.java">ResourceType</a> interface, which is listed in the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/tree/master/src/main/java/model/data/type">'model.data.type`</a> package. This package defines format types for each type of Data that Piazza currently supports: <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/data/type/ShapefileDataType.java">Shapefiles</a>, <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/data/type/TextDataType.java">Text</a>, <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/data/type/PostGISDataType.java">PostGIS Tables</a>, etc.

The `host` parameter is set to true if Piazza should host the data internally. This should be the default behavior. If this is set to false, then Piazza will not store the data in its internal storage. It will merely provide a link to wherever this external data resides, and attempt to read whatever metadata it can. If you specify a `file` in the Multipart POST, and set the ingest flag `host` to `false`, then an error will be raised - this is because setting `host` to `false` is explicitly stating to the Ingest component that no data should be stored - only metadata.

When loading data, users will be encouraged to fill out as much `metadata` as possible, which follows the form of the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/job/metadata/ResourceMetadata.java">ResourceMetadata</a> POJO.

## Ingest Process

The Gateway will receive the Ingest Job request and then forward the request along, via Kafka, to the Ingest component. If a file is specified in the initial request, the Gateway will store this file on disk immediately and then upload to AWS S3 storage. The S3 File path information is then attached to the message that the Ingest receives.

As the message is consumed by the Ingest component, the first thing is to parse out any available metadata from the user request. Additionally, any other available metadata is also automatically extracted based on file paths or resource URLs specified. This metadata information is stored in the Mongo Database in the Resources collection. This collection stores all information for each bit of data Ingested into Piazza.

## Supported Data Types

The following table outlines the supported data types in piazza:

<table class="table">
	<thead>
		<tr>
			<th>Data Type</th>
			<th>Ingest and Hosted</th>
			<th>Ingest and Not Hosted</th>
		</tr>
	</thead>
	<tbody>
		<tr class="odd">
			<td>Text</td>
			<td>Yes, stored in MongoDB, or file</td>
			<td>Not Applicable</td>
		</tr>
		<tr class="even">
			<td>Shapefile</td>
			<td>Yes, stored in PostGIS + raw file</td>
			<td>Possibly, if we have credentials passed to us</td>
		</tr>
		<tr class="odd">
			<td>GeoTIFF</td>
			<td>Yes, stored in S3</td>
			<td>Possibly, if we have credentials passed to us</td>
		</tr>
		<tr class="even">
			<td>PointCloud</td>
			<td>Yes, stored in S3</td>
			<td>Possibly, if we have credentials passed to us</td>
		</tr>
		<tr class="odd">
			<td>Web Feature Service</td>
			<td>Yes, stored in PostGIS</td>
			<td>Yes, referenced via external URL</td>
		</tr>
	</tbody>
</table>

## Example Ingest Requests

### Text Ingest

Great for testing! This will upload some Text into Piazza and will be stored within the Resource database. The JSON Payload for this request takes on this form:

    {
        "type": "ingest",
        "host": true,
        "data" : {
            "dataType": {
                "type": "text",
                "mimeType": "application/text",
                "content": "This text itself is the raw data to be ingested. In reality, it could be some GML, or GeoJSON, or whatever."
            },
            "metadata": {
                "name": "Testing some Text Input",
                "description": "This is a test.",
                "classType": { "classification": "unclassified" }
            }
        }
    }

### Shapefile Ingest

    {
        "type": "ingest",
        "host": true,
        "data" : {
            "dataType": {
                "type": "shapefile"
            },
            "metadata": {
                "name": "My Test Shapefile",
                "description": "This is a test.",
                "classType": { "classification": "unclassified" }
            }
        }
    }

### GeoTIFF Ingest

GeoTIFF Raster files can be ingested.

        "type": "ingest",
        "host": "true",
        "data" : {
            "dataType": {
                "type": "raster"
            },
            "metadata": {
                "name": "My Test Raster",
                "description": "This is a test.",
                "classType": { "classification": "unclassified" }
            }
        }

### GeoJSON Ingest

        "type": "ingest",
        "host": "true",
        "data" : {
            "dataType": {
                "type": "geojson"
            },
            "metadata": {
                "name": "My Test GeoJSON",
                "description": "This is a test.",
                "classType": { "classification": "unclassified" }
            }
        }

### Web Feature Service (WFS) Ingest

Web Feature Services can be ingested and hosted within Piazza. If `host` is set to true, then Piazza will store the WFS data pulled from the provided endpoint into the Piazza PostGIS database. If the WFS is not able to be parsed, then an error will be thrown. All WFS URLs provided to Piazza must be accessible to the Ingest component. If advanced credentials or authentication is required, then it must be specified or else the request will fail (currently, WFS credentials are not implemented).

        "type": "ingest",
        "host": "true",
        "data" : {
            "dataType": {
                "type": "wfs",
                "url": "http://geoserver.dev:8080/geoserver/wfs",
                "featureType": "piazza:shelters",
                "version": "1.0.0"
            },
            "metadata": {
                "name": "My Test WFS",
                "description": "This is a test.",
                "classType": { "classification": "unclassified" }
            }
        }

## Workflow Events

In support of the <a target="_blank" href="https://github.com/venicegeo/pz-workflow">Workflow</a> service, the Ingest component is capable of firing events, consumed by the Workflow, in order to let other Piazza components become aware of when new Data has been Ingested into Piazza.

### Event Type

Upon the successful Ingest of any type of Data into Piazza (internal or external), the Ingest component will fire an Event. The Event is defined with the Workflow using the following template:

    {
        "name": "Ingest",
        "mapping": {
            "dataId": "string",
            "dataType": "string",
            "epsg": "short",
            "minX": "long",
            "minY": "long",
            "maxX": "long",
            "maxY": "long",
            "hosted": "boolean"
        }
    }

## Administrative API

The Ingest Component contains various REST Endpoints that can be used for query for run-time information on specific instances of this component.

### Administrative Statistics
`GET /admin/stats`

Return object containing information regarding the running instance of this component. This will return the list of Job IDs of currently processing Jobs owned by this component.

    {
        "jobs": ["job-id-1", "job-id-2"]
    }
