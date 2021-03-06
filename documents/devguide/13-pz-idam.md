# Identity and Access Management (IDAM)

The Piazza Core pz-idam project is an internal component that provides REST endpoints for handling Authentication and Authorization. This is done by brokering the Authentication (AuthN) functionality to an external service (in this case, GEOAxIS); and using an internal series of interfaces for providing Authorization (AuthZ). This project is used by the Gateway in order to generate API Keys and provide full AuthN/AuthZ capabilities.

## Building and Running Locally

Please refer to repository <a target="_blank" href="https://github.com/venicegeo/pz-idam">README</a>

## Code Organization

The pz-idam project uses a series of Spring RestControllers in order to manage the number of REST Endpoints that the pz-idam API provides. These are located in the <a target="_blank" href="https://github.com/venicegeo/pz-idam/tree/master/src/main/java/org/venice/piazza/idam/controller">org.venice.piazza.idam.controller</a> package, and are broken up into separate controllers by their functionality.

## API Keys and User Profiles

All Piazza requests are authenticated and authorized using a Piazza-owned API Key. This API Key is stored and maintained in the IDAM project. In order to generate an API Key, IDAM delegates initial AuthN checks to an external authority (GEOAxIS). Once a user has proven their authentication to this external authority, then it creates a User Profile for that user and an API Key that is returned to the user. That user then associates that API Key along with every request they make through the Gateway. The Gateway, upon receiving requests, will delegate the AuthN/AuthZ checks for that specific API Key to this IDAM component. IDAM will verify that the key exists and is valid, and will check that the associated User Profile has authorization to access the specific resource they are trying to reach.

Each User Profile is associated with a single API Key. This API Key can be reset and recreated, but only one API Key is allowed per User Profile. User Profiles also contain information such as creation date, and also allows the user to track their activity in Piazza, such as the number of jobs they have submitted for a particular day.

## Local Debugging

When building pz-idam locally, it can be beneficial to disable the AuthN functionality of the component, which would otherwise reach out to the external authority for user accounts. In order to disable this, a local developer can set the `spring.profiles.active` to `disable-authn` which will disable all AuthN functionality. In this way, IDAM can be debugged locally without having to reach to an external provider.

## Authentication

The <a target="_blank" href="https://github.com/venicegeo/pz-idam/blob/master/src/main/java/org/venice/piazza/idam/authn/PiazzaAuthenticator.java">PiazzaAuthenticator</a> interface is defined in the <a target="_blank" href="https://github.com/venicegeo/pz-idam/tree/master/src/main/java/org/venice/piazza/idam/authn">org.venice.piazza.idam.authn</a> package. This is the interface that allows IDAM to determine Authentication credentials for allowing access to generation of API Keys. It currently contains one implementation, for GEOAxIS. This authenticates a set of credentials and provides back an Authentication Response, either successful login or failed attempts. In order to add new authentication providers, simply extend this interface and implement the appropriate methods.

These methods return the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/response/AuthResponse.java">AuthResponse</a> model, defined in <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon">JobCommon</a>, which contains information as to whether or not the authentication succeeds, and if it does, it also contains a link to the UserProfile object which contains information on the user as provided through the authentication provider.

## Authorization

The <a target="_blank" href="https://github.com/venicegeo/pz-idam/blob/master/src/main/java/org/venice/piazza/idam/authz/Authorizer.java">Authorizer</a> interface is defined in the <a target="_blank" href="https://github.com/venicegeo/pz-idam/tree/master/src/main/java/org/venice/piazza/idam/authz">org.venice.piazza.idam.authz</a> package and contains an interface for implementing authorization. IDAM REST controller contains endpoints which perform authorization by checking if a Piazza API Key is authorized to perform a specific action. These actions are described in the <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/security/authz/AuthorizationCheck.java">AuthorizationCheck</a> model, which defines a <a target="_blank" href="https://github.com/venicegeo/pz-jobcommon/blob/master/src/main/java/model/security/authz/Permission.java">Permission</a> object that outlines a specific HTTP Method and a URI. In this way, users can be granted fine-level authorization on every REST endpoint in the Piazza system.

Many authorizers can be chained together in order to expand the functionality of the IDAM component. If new authorizers should be added, then simply create a new package under <a target="_blank" href="https://github.com/venicegeo/pz-idam/tree/master/src/main/java/org/venice/piazza/idam/authz">org.venice.piazza.idam.authz</a> and create a class implementing the <a target="_blank" href="https://github.com/venicegeo/pz-idam/blob/master/src/main/java/org/venice/piazza/idam/authz/Authorizer.java">Authorizer</a> interface.
