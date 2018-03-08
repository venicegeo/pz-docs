# Pz Service Controller

The Service Controller is handles the registration and execution of user services and algorithms. It acts as a broker to external services that allows users (developers) to host their own algorithmic or spatial services directly from within Piazza. Other external users can then run these algorithms with their own data. In this way, Piazza acts as a federated search for algorithms, geocoding, or other various microservices (spatial or not) to run within a common environment. Using the Piazza Workflow component, users can create workflows that will allow them to chain events together (such as listening for when new data is loaded into Piazza) in order to create complex, automated workflows. This satisfies one of the primary goals of Piazza: Allowing users across the GEOINT Services platform to share their data and algorithms amongst the community.

## Service Registration Types

There are three types of services, to support a variety of different workflows for existing REST services. The type of a Service is specified during registration of the Service.

To external users who are merely interacting with Services by executing them, these different types are entirely transparent. The differences only lie in the underlying execution of that Service.

For detailed explanations on any of these Service Types, please see the [Users Guide on Services](/userguide/5-userservices).

The first type is the *standard* type of Service registration. To specify this type, no additional parameters must be added to the registration payload - it is the default type. This will register a URL endpoint (and a method) that will be called whenever the user executes the Service through the Gateway. ServiceController will contact the service directly with the specified parameters and then store the result that is returned from the Service. This is the most simple form of execution.

The second type is the *asynchronous* type. This can be specified by saying `isAsynchronous: true` in the service Registration payload. This type handles cases where the external Service has some sort of internal job queueing mechanism that can be used in order to defend against a large amount of requests being sent to the server that could potentially overwhelm and crash the server. Using this type of Registration, the ServiceController will contact the Service initially with the inputs for an execution. That request is expected to immediately return with a unique Job ID (provided by the Service). ServiceController will then periodically query the Service for status on that particular job. When the Status is reported back as Success, then the ServiceController will make an additional request to acquire the results and store them in Piazza.

The last type is the *taskManaged* type. This is specified by saying *isTaskManaged: true* in the service Registration payload. This is designed to support the case where an existing Service has no job management system, or any way to defend against large amounts of requests. Using this Task Managed case, Service Executions will be placed in a Jobs Queue for that particular Service - no external request is made to the Service. Instead, the Service polls Piazza for Jobs in its queue for that Service. In this way, the Service is able to retrieve work only when it is able to handle it. Piazza performs the role of load balancing and job queueing for this Service. When results for a particular job are completed, then the external service sends those results directly back to Piazza.

## Building and Running Locally

Please refer to the repository [README](https://github.com/venicegeo/pz-servicecontroller)
