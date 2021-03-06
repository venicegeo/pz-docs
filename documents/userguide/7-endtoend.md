# End-to-End Example

In this section, a workflow will be described to make use of
pzsvc-file-watcher, pzsvc-preview-generator, and other Piazza components
to automatically crop files uploaded to a given S3 bucket.

## Setting Up pzsvc-file-watcher

The pzsvc-file-watcher automatically watches for uploaded files to the
S3 bucket and ingests them to the Piazza service.

To begin, clone the pzsvc-file-watcher from its <a target="blank" href="https://github.com/venicegeo/pzsvc-file-watcher">GitHub repository</a>:

    $ git clone https://github.com/venicegeo/pzsvc-file-watcher

Next, install pzsvc-file-watcher’s dependencies:

    $ cd pzsvc-file-watcher
    $ [sudo] pip2 install -r requirements.txt

pzsvc-file-watcher takes a few command line arguments, including the S3
bucket location, the user’s AWS access key and private key, and the
user’s Piazza UserName and Gateway host name. AWS credentials are
checked for in the `s3.key.access` and `s3.key.private` environment
variables and can also be supplied via command line. Additionally, the
S3 bucket name can be specified in the `s3.bucket.name` environment
variable, and the `PZKEY` environment variable is checked for the value
of the user’s Piazza API Key. In addition, the Piazza Gateway Host
should be specified with `PZSERVER`.

An example of running `filewatcher.py` via the command line is below:

    $ python2 filewatcher.py -b 'aws_bucket_name' -g 'https://pz-gateway.{{PZDOMAIN}}' -a 'aws_access_key' -p 'aws_private_key' -k 'piazza_api_key'

This will set up the pzsvc-file-watcher to poll continuously for new
files in the `aws_bucket_name` bucket and ingest those files, without
hosting them, to the Piazza service.

The output of running the filewatcher will look something like the
following:

    Listening for new files in AWS bucket test_bucket
    Piazza Gateway: https://pz-gateway.venicegeo.io
    Successful request for ingest of file 0272f68b-b979-4f5f-95d0-1e2d0f96133a-elevation.tif of type raster

This response means that the ingest request was received by the Piazza
Gateway.

## Registering the pzsvc-preview-generator Service

The purpose of
<a target="blank" href="https://github.com/venicegeo/pzsvc-preview-generator">pzsvc-preview-generator</a>
is to showcase Piazza’s core capabilities. This app exposes a REST
endpoint that receives a POST request containing a payload of required
parameters. Given an S3 location, it downloads a raster file, crops the
image, uploads the cropped raster back up to S3 bucket, and returns a
DataResource.

A script to register this service is located at
<a target="blank" href="scripts/register-crop-service.sh">register-crop-service.sh</a>.
Registering the cropping service is easy:

    $ ./register-crop-service.sh

## Executing the Service

The <a target="blank" href="scripts/execute-crop-service.sh">execute-crop-service.sh</a> script
takes a few more parameters. They include the `serviceId` returned from
registering the previous service (the `serviceId` will be printed out if
the previous script is successful), the AWS bucket name where the file
is located, and the filename to crop. For example:

    $ ./execute-crop-service.sh {{serviceId}} {{bucketname}} {{filename}}

The script does the equivalent of the send a POST request with a payload
to `https://pz-svcs-prevgen.venicegeo.io/crop`

Sample working payload:

    {
        "source": {
            "domain": "s3.amazonaws.com",
            "bucketName": "pz-svcs-prevgen",
            "fileName": "NASA-GDEM-10km-colorized.tif"
        },
        "function": "crop",
        "bounds": {
            "minx": -140.00,
            "miny": 10.00,
            "maxx": -60.00,
            "maxy": 70.00
        }
    }

## Retrieving Results

The service will download the file from pz-svcs-prevgen S3 bucket and
crop it with given bounding box information. The cropped result tif will
be uploaded back up to the <a target="blank" href="https://console.aws.amazon.com/s3/home?region=us-east-1#&bucket=pz-svcs-prevgen-output&prefix=">pz-svcs-prevgen-output S3 bucket</a>.

The `execute-crop-service.sh` script should return a `jobId` that can
then be passed as an argument to
<a target="blank" href="scripts/get-job-info.sh">get-job-info.sh</a>:

    $ ./get-job-info.sh {{jobId}}

When the job is complete, the resulting data can be queried from the
`dataId` returned by the `get-job-info.sh` script using
<a target="blank" href="scripts/get-data-info.sh">get-data-info.sh</a>:

    $ ./get-data-info.sh {{dataId}}

If all goes well, the resulting received payload will be of DataResource
type:

    {
        "dataType": {
            "type": "raster",
            "location": {
                "type": "s3",
                "bucketName": "pz-svcs-prevgen-output",
                "fileName": "478788dc-ac85-4a85-a75c-cbb352620667-NASA-GDEM-10km-colorized.tif",
                "domainName": "s3.amazonaws.com"
            },
            "mimeType": "image/tiff"
        },
        "metadata": {
            "name": "External Crop Raster Service",
            "id": "478788dc-ac85-4a85-a75c-cbb352620667-NASA-GDEM-10km-colorized.tif",
            "description": "Service that takes payload containing s3 location and bounding box for some raster file, downloads, crops and uploads the crop back up to s3.",
            "url": "http://host:8086/crop",
            "method": "POST"
        }
    }

The resulting file can be retrieved from the bucket with the bounding
box applied to it.
