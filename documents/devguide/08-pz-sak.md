# SAK (Development/Debug UI Tool)

While the communication with Gateway primarily is performed by NPEs
through HTTP(S) requests via RESTful interfaces, the Swiss Army Knife
(SAK) is a UI front end for testing, demonstrating and administration of
Piazza services. SAK is a web application that administrative users can
log into to execute certain requests through the Gateway, and more
importantly, track logging and other reporting information about the
internal details of Piazza. This tool is intended for administrative
users only; those who needs direct access to Piazza outside of just the
user API.

SAK will be used by developers as an easy way to test the functionality
of the services. It uses HTML/CSS/Javascript to make HTTP calls to
Piazza services and runs inside of <a target="_blank" href="http://nginx.org/">NGINX</a>. The UI is
unit tested using <a target="_blank" href="https://karma-runner.github.io/0.13/index.html">Karma</a>
and <a target="_blank" href="http://jasmine.github.io/2.4/introduction.html">Jasmine</a>.

## Source Organization

This app is setup as a static web application and is a single module
AngularJS app. The important sections include:

-   `/conf` - This contains an example config file for a local version of nginx

-   `/public` - This contains all of the source code and what actually gets deployed to nginx

-   `/public/nginx.conf` - This is the config file that nginx uses on the deployed server

## Running SAK locally

### Requirements

-   Code cloned from <a target="_blank" href="https://github.com/venicegeo/pz-sak">https://github.com/venicegeo/pz-sak</a>

```
    git clone https://github.com/venicegeo/pz-sak.git
```
    
-   <a target="_blank" href="http://nginx.org/en/download.html">Nginx 1.8.1</a>

### Steps

1.  Copy pz-sak/conf/nginx.conf to nginx-1.8.1/conf

2.  Modify nginx.conf to point root to your local copy of the repository’s /public directory (line 50)

3.  From a command line run `start nginx.exe`

4.  Go to <a target="_blank" href="http://localhost">http://localhost</a>

Note: The following commands are helpful as well:

-   `nginx -s reload` - Updates changes to the conf

-   `nginx -s quit` - Shuts down nginx

Troubleshooting:

-   If you’re having trouble with your proxies, it may be because your
    network is preventing 8.8.8.8 from resolving as the default DNS. You
    can just replace that with the DNS that your machine uses. You can
    find your DNS by running `ipconfig /all` in Windows. It’s important
    to configure the proper DNS for your network for dynamic proxies to
    work properly.

## Running SAK from the cloud

### Requirements

-   Web-browser (we typically test in Chrome but any modern browser should work)

### Steps

1.  Open your web-browser

2.  Go to: <a target="_blank" href="http://pz-sak.venicegeo.io/">http://pz-sak.venicegeo.io/</a>

## Using SAK

### Login

In order to login to SAK you may need credentials for your Piazza
installation. If you do not yet have a username and password, please
contact us.

### Sections of SAK

Upon login, you are redirected to the Home page where you are given a
list of commonly used links and locations of services. Here are further
details on using these services through SAK.

### SAK Access

In this section you can list all pieces of data that have been loaded
into Piazza. If you’re looking for something specific, you can look up
the data object by it’s Data ID. All data is returned in raw JSON
format, so you can view the response as close to what services that
connect to Piazza would be seeing.

### SAK Jobs

Here you can check the status of specific jobs using the Job ID,
retrieve resource data with a Data ID, or just browse through all the
jobs that have been requested.

### SAK Loader

The loader allows the upload of text and files into the Piazza system.
Currently supported through the UI, the user may choose Text to load or
Select a GeoTIFF that they have locally. The metadata field can be a
JSON object such as the following:

    {
      "name": "Metadata name",
      "key": "value"
    }

When the user selects Text, the Content is the text to be loaded. When
the user selects File, the user should then use the file selector to
choose the appropriate file from the local storage.

Coming soon:

The Piazza service support more file types - like shapefiles and geojson
- as well as links to outside files (not necessarily in local storage).
Also supported is files that won’t be hosted by Piazza, but just linked
to another source. SAK will support all of these use cases in the future
but currently only supports Text and GeoTIFF.

### User Service Registry

This is where a user can Register, Execute, and manage services. If you
have a service that you would like to run within the Piazza system, you
just have to register your service here. The short form requires:
Service Name, Method, Service URL, Response Type, and Description.
Currently, the url has to be something that is accessible for Piazza to
actually get to it. Once the service is registered you will be given a
service ID to be used for calling the service.

Executing the service involves entering JSON for the system to know
where the service is and what parameters to pass to the service. The
following is a very simple example of what to put in this field:

    {
        "type": "execute-service",
        "data": {
            // The unique identifier for your service
            "serviceId": "00af1e83-167b-43c1-b60b-16c2b8d7be2f",

            // Any inputs that your service will expect
            "dataInputs": {},

            // A list of outputs that your service will be responding with
            "dataOutput": [{
                "mimeType":"application/json",
                "type":"text"
            }]
        }
    }

Other options available for User Service registry include: \* List -
here you can list all services, update and delete services \* Search -

### Design

SAK uses AngularJS and Bootstrap to create a simple UI for accessing
REST endpoints exposed through Piazza services. Each Piazza service will
be listed in the left tree pane. When selecting a service any functions
associated will be listed on the page that appears, and some services
will have more functions than others.

## UI mockups 
![UI mockups](images/sak-tree-branches.png)
