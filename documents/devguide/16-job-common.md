# Job Common

The Job Common (or Java Common) project is a Java library that contains
various useful utility classes and serializable models that are used
commonly throughout the Java applications in the Piazza Core.

## Building and Running Locally

For instructions on how to include this library in your Java project,
through Maven, please see the [Repo
Documentation](https://github.com/venicegeo/pz-jobcommon). This contains
all information needed to connect to the Piazza S3 Maven repository and
include the Common library as a dependency in your `pom.xml` file.

## Spring Beans

This project contains a variety of Spring Beans that are used to wrap
core Piazza services, such as the Logger, in order to provide a handy
Java API for interactions that conform to Spring standards.

**IMPORTANT**: `PiazzaLogger` and is created with `@Component`
annotations, and can thus be `@Autowired` into your classes as normal.
However, since these Beans are defined in an external project
(`pz-jobcommon`) then one slight change to your project annotation must
be made to your Application file:

    @SpringBootApplication
    @ComponentScan({ "MY_NAMESPACE, util" })
    public class Application extends SpringBootServletInitializer {

In the above syntax, the `@ComponentScan()` annotation was added. This
is required in order to tell Spring to search for `@Components` in
additional namespaces to your own. In this case, we are telling Spring
to look in the `MY_NAMESPACE` package, which is a placeholder for your
projects own namespace (such as `gateway` or `jobmanager`) — this will
ensure your own project Components get picked up. Additionally, we tell
Spring to look for Components in the `util` namespace which is defined
in the `pz-jobcommon` project and contains the `PiazzaLogger` and
`UUIDFactory` classes.

The above lines are required because, if not specified, Spring would
only look for Components in the default project namespaces (represented
by the placeholder `MY_NAMESPACE`) and would not find the components
located in the `util` package, and thus you would receive errors when
attempting to Autowire something like the `PiazzaLogger`.

If you do not wish to use the `PiazzaLogger` classes as Autowired
Components in your application (which is highly recommended!) then you
are free to instantiate them as normal using the provided constructors.
However, this is discouraged because you will have to inject the `url`
values for each component directly from the constructor in order for
these classes to function. It is much preferred to Autowire these
components with appropriate `url` values (described in the below
sections for each component) and letting Spring instantiate this for
you.

# PiazzaLogger

Provides a Java API to the
[pz-logger](https://github.com/venicegeo/pz-logger) component.

The PiazzaLogger Bean has required property values. These must be placed
in your `application.properties` or `application-cloud.properties` file
in order for these components to work when Autowired.

    logger.name=COMPONENT_NAME
    logger.console=true
    vcap.services.pz-elasticsearch.credentials.transportClientPort=9300
    vcap.services.pz-elasticsearch.credentials.hostname=localhost
    LOGGER_INDEX=piazzalogger
    elasticsearch.clustername=venice

The elastic search information must be included in the specified
property names. In Cloud Foundry, this will point to the elastic search
service.

If you want the `PiazzaLogger` class to also write to your local console
(useful for debugging!) then you can specify the `logger.console`
configuration value to `true`. All statements will then also be directed
out to your local console.

Incorporating the `PiazzaLogger` class as a Component is simple.

    @Autowired
    private PiazzaLogger logger;

Logs can then be sent using the `.log(message, severity)` method. The
`message` is simply the message you wish to Log. The `severity` is a
list of acceptable severity levels defined in the `PiazzaLogger` class.

    public static final String DEBUG = "Debug";
    public static final String ERROR = "Error";
    public static final String FATAL = "Fatal";
    public static final String INFO = "Info";
    public static final String WARNING = "Warning";

Please reference these static variables when sending your Logs. For
example:

    @Autowired
    private PiazzaLogger logger;

    logger.log("Something went wrong!", PiazzaLogger.ERROR);

## Models

`pz-jobcommon` also contains a variety of models that map all of the
JSON payload information that is passed throughout the Gateway and other
internal components. These models are located in the `model.*`
namespace. These models are documented in the Swagger documentation,
with regards to their usage in the Gateway API.
