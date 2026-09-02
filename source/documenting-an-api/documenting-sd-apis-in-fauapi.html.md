

# Documenting Schools Digital APIs in FaUAPI 

- [Introduction](#introduction)
- [When Should FaUAPI Be Used?](#when-should%C2%A0fauapi%C2%A0be-used)
- [Useful Links](#useful-links)
	- [Pre-Production](#pre-production)
		- [Manage an API Portal](#manage-an-api-portal)
		- [API Catalogue](#api-catalogue)
		- [Automation API Schema](#automation-api-schema)
	- [Production](#production)
		- [Manage an API Portal](#manage-an-api-portal)
		- [API Catalogue](#api-catalogue)
		- [Automation API Schema](#automation-api-schema)
	- [Documentation and Support](#documentation-and-support)
		- [FaUAPI SharePoint](#fauapi%C2%A0sharepoint)
		- [Getting Started Guide](#getting-started-guide)
- [Permissions and Access to FaUAPI](#permissions-and-access-to%C2%A0fauapi)
	- [API Catalogue](#api-catalogue)
		- [Typical Users](#typical-users)
	- [Manage an API Portal](#manage-an-api-portal)
		- [Typical Users](#typical-users)
- [Adding an API to FaUAPI](#adding-an-api-to%C2%A0fauapi)
	- [Option 1: Manual Registration](#option-1-manual-registration)
	- [Option 2: Import a FaUAPI Manifest](#option-2-import-a%C2%A0fauapi%C2%A0manifest)
- [Creating a FaUAPI Manifest](#creating-a%C2%A0fauapi%C2%A0manifest)
	- [Example Manifest (August 2026)](#example-manifest%C2%A0august-2026)
	- [Manifest Field Descriptions](#manifest-field-descriptions)
	- [Generating the Manifest](#generating-the-manifest)
- [Automating FaUAPI Publication](#automating%C2%A0fauapi%C2%A0publication)
	- [Example Automation Flow](#example-automation-flow)
	- [Reference Implementation](#reference-implementation)

## Introduction 

Find and Use an API (FaUAPI) is the Department for Education's API catalogue and API management platform. 

There is a departmental requirement to use FaUAPI for: 
- Public-facing APIs. 
- Internal APIs that are consumed by other DfE teams, services or applications. 

Currently, the minimum requirement is to ensure these APIs are documented within FaUAPI. 

This guidance describes the recommended approach for documenting APIs within FaUAPI, with a preference for automating publication. 

This document focuses on API documentation and publication within FaUAPI. 

It is not intended to provide guidance on hosted APIs, API products, subscriptions, application registrations, client onboarding or external client management. 

For these topics, refer to the [FaUAPI Sharepoint](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Feducationgovuk.sharepoint.com.mcas.ms%2Fsites%2Flvewp00121%3Fxsdata%3DMDV8MDJ8fDJkNjcwYjJkZGY1NjRiZjc1YmVmMDhkZWUwZTQ2MDg4fGZhZDI3N2M5YzYwYTRkYTFiNWYzYjNiOGIzNGE4MmY5fDB8MHw2MzkxOTU0Njg2MDk5MDM1OTl8VW5rbm93bnxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKRFFTSTZJbFJsWVcxelgwRlVVRk5sY25acFkyVmZVMUJQVEU5R0lpd2lWaUk2SWpBdU1DNHdNREF3SWl3aVVDSTZJbGRwYmpNeUlpd2lRVTRpT2lKUGRHaGxjaUlzSWxkVUlqb3hNWDA9fDF8TDJOb1lYUnpMekU1T20xbFpYUnBibWRmVFRKUmVsbDZSVEZOZW1kMFdWUkZOVTFUTURCT2JVcG9URlJvYVU5VVVYUk9SMHBvVGtSU2JFMVVVWGxaVkZrMVFIUm9jbVZoWkM1Mk1pOXRaWE56WVdkbGN5OHhOemd6T1RVd01EVTVNREF6fDY3ODkxYmQxYWE1MzQ5NDE1YmVmMDhkZWUwZTQ2MDg4fDRhMDJkMTU4MDNlMzQ2YjQ5OTYzMmU5OWE3ZGRmZmIz%26sdata%3DemR2UmZEdGg4N2ZtR3paVWtHNEFDR2pXRnJLU1VkcG5DSGN6ZVBiMU5uQT0%253D%26ovuser%3Dfad277c9-c60a-4da1-b5f3-b3b8b34a82f9%252CAmarjit.SINGH-ATWAL%2540EDUCATION.GOV.UK%26TeamsCID%3Deb798cd6-e413-44ef-962b-b1d90484a037%26OR%3DTeams-HL%26CT%3D1784030443916%26clickparams%3DeyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIxNDE1LzI2MDYxMTE4MjE2IiwiSGFzRmVkZXJhdGVkVXNlciI6ZmFsc2V9%26McasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) site and associated service documentation. 

## When Should FaUAPI Be Used? 

FaUAPI is the Department for Education standard for API discovery and management. 

FaUAPI should be used when: 
- An API is consumed by another DfE service or team. 
- An API is consumed by another government department.
- An API is consumed by an external organisation or partner. 
- API consumers need to discover, subscribe to or access the API. 
- API ownership and support information needs to be visible to consumers. 
    
FaUAPI is generally not required when: 
- An API is only consumed by its own front-end application. 
- There are no consumers outside of the service boundary. 
- The API is purely an internal implementation detail. 
- No external subscriptions or discovery mechanisms are required. 

As a simple rule:

If anyone other than your own application needs to discover, access or subscribe to the API, it should probably be documented within FaUAPI. 

## Useful Links 

### Pre-Production 

#### Manage an API Portal 
[https://pp-apimanagement.education.gov.uk/](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fpp-apimanagement.education.gov.uk.mcas.ms%2F%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

Used to create, maintain and publish API documentation. 

#### API Catalogue 
[https://pp-find-and-use-an-api.education.gov.uk/](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fpp-find-and-use-an-api.education.gov.uk.mcas.ms%2F%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

Used to verify API publication and consumer experience in a non-production environment. 

#### Automation API Schema 
[https://pp-apimanagement.education.gov.uk/api/schema/index.html](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fapimanagement.education.gov.uk.mcas.ms%2Fapi%2Fschema%2Findex.html%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

### Production 

#### Manage an API Portal 
[https://apimanagement.education.gov.uk/](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fapimanagement.education.gov.uk.mcas.ms%2F%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

Used to manage production API documentation and metadata. 

#### API Catalogue 
[https://beta-find-and-use-an-api.education.gov.uk/](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fbeta-find-and-use-an-api.education.gov.uk.mcas.ms%2F%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

Used by API consumers to discover and access published APIs. 

#### Automation API Schema 
[https://apimanagement.education.gov.uk/api/schema/index.html](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fapimanagement.education.gov.uk.mcas.ms%2Fapi%2Fschema%2Findex.html%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

### Documentation and Support 

#### FaUAPI SharePoint 

The  [FaUAPI Sharepoint](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Feducationgovuk.sharepoint.com.mcas.ms%2Fsites%2Flvewp00121%3Fxsdata%3DMDV8MDJ8fDJkNjcwYjJkZGY1NjRiZjc1YmVmMDhkZWUwZTQ2MDg4fGZhZDI3N2M5YzYwYTRkYTFiNWYzYjNiOGIzNGE4MmY5fDB8MHw2MzkxOTU0Njg2MDk5MDM1OTl8VW5rbm93bnxWR1ZoYlhOVFpXTjFjbWwwZVZObGNuWnBZMlY4ZXlKRFFTSTZJbFJsWVcxelgwRlVVRk5sY25acFkyVmZVMUJQVEU5R0lpd2lWaUk2SWpBdU1DNHdNREF3SWl3aVVDSTZJbGRwYmpNeUlpd2lRVTRpT2lKUGRHaGxjaUlzSWxkVUlqb3hNWDA9fDF8TDJOb1lYUnpMekU1T20xbFpYUnBibWRmVFRKUmVsbDZSVEZOZW1kMFdWUkZOVTFUTURCT2JVcG9URlJvYVU5VVVYUk9SMHBvVGtSU2JFMVVVWGxaVkZrMVFIUm9jbVZoWkM1Mk1pOXRaWE56WVdkbGN5OHhOemd6T1RVd01EVTVNREF6fDY3ODkxYmQxYWE1MzQ5NDE1YmVmMDhkZWUwZTQ2MDg4fDRhMDJkMTU4MDNlMzQ2YjQ5OTYzMmU5OWE3ZGRmZmIz%26sdata%3DemR2UmZEdGg4N2ZtR3paVWtHNEFDR2pXRnJLU1VkcG5DSGN6ZVBiMU5uQT0%253D%26ovuser%3Dfad277c9-c60a-4da1-b5f3-b3b8b34a82f9%252CAmarjit.SINGH-ATWAL%2540EDUCATION.GOV.UK%26TeamsCID%3Deb798cd6-e413-44ef-962b-b1d90484a037%26OR%3DTeams-HL%26CT%3D1784030443916%26clickparams%3DeyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIxNDE1LzI2MDYxMTE4MjE2IiwiSGFzRmVkZXJhdGVkVXNlciI6ZmFsc2V9%26McasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) site should be considered the authoritative source for service information, standards, support processes and onboarding guidance. 

#### Getting Started Guide 
[https://beta-find-and-use-an-api.education.gov.uk/docs/getting-started](https://mcas-proxyweb.mcas.ms/certificate-checker?login=false&originalUrl=https%3A%2F%2Fbeta-find-and-use-an-api.education.gov.uk.mcas.ms%2Fdocs%2Fgetting-started%3FMcasTsid%3D15600&McasCSRF=3f5859f882e25d09644037b84c5866798854c134811893e5e58315430200c5b1) 

## Permissions and Access to FaUAPI 

Different levels of access may be required depending on your role. 

### API Catalogue 

The API Catalogue provides read-only access to: 
- API documentation 
- API metadata 
- Contact information 
- Subscription information 
- OpenAPI specifications 
    
Access requires a GOV.UK One Login account. Existing GOV.UK One Login credentials can be used, or a new account can be created as required. Note that a @education email will be able to see APIs with the visibility level "DfE Internal". Other domains only see APIs with the visibility level "Public". 

#### Typical Users 
- Developers 
- Technical Leads 
- Delivery Managers 
- Architects 
- External consumers 

### Manage an API Portal 

The Manage an API portal is used to: 

- Create APIs 
- Publish APIs 
- Update API metadata 
- Manage OpenAPI specifications 
- Manage subscriptions 
- Configure visibility settings 

Access requires: 
- A DfE Azure Active Directory account (@education.gov.uk) 
- Appropriate workspace permissions (Admin or API Developer) 
- Membership of the relevant FaUAPI workspace 

#### Typical Users 
- Technical Leads 
- Senior Developers 
- Service Owners 
- API Product Owners 
- Support Users  
    

If a workspace does not already exist, or additional permissions are required, contact the FaUAPI team. 

## Adding an API to FaUAPI 

### Option 1: Manual Registration 

1. Log in to the appropriate Manage an API portal. 
2. Navigate to your workspace. 
3. Create a new Linked API. 
4. Complete the API metadata fields. 
5. Upload the OpenAPI specification. 
6. Review the generated documentation. 
7. Save and publish the API. 

Once published, the API will become visible within the FaUAPI catalogue according to its configured visibility settings. 

### Option 2: Import a FaUAPI Manifest 

Rather than entering API metadata manually, FaUAPI supports importing a manifest file containing API metadata and configuration. 

This is the preferred approach because it: 
- Reduces manual effort.
- Improves consistency. 
- Supports automation. 
- Removes duplication. 
- Helps keep documentation aligned with deployed applications. 

For most services, the manifest should be generated automatically as part of the deployment process. 

## Creating a FaUAPI Manifest 

A FaUAPI manifest contains the metadata required to publish and maintain an API within FaUAPI. 

### Example Manifest (August 2026) 

``` JSON
{ 
  name: "register-trainee-teachers-api", 
  displayName: "Register trainee teachers API", 
  description: "The Register API allows providers to import trainee records from their student record systems and to keep those records synchronised as they are modified.", 
  overview: "Register API Public Interface\r\nFull documentation is available here:\r\n[Register API documentation - Register trainee teachers](https://www.register-trainee-teachers.service.gov.uk/api-docs)", 
  siteUrl: "https://www.register-trainee-teachers.service.gov.uk/api-docs", 
  backendType: "http", 
  majorVersion: "<major_version>", 
  visibility: "Public", 
  tags: "register;api;itt", 
  classification: "Public facing", 
  serviceLevel: "24/7", 
  technology: "REST, Ruby on Rails", 
  usage: "HEI ITT providers and SRS vendors", 
  environments: [ 
    { name: "dev", backendUrl: "https://sandbox.register-trainee-teachers.service.gov.uk", visibility: "Public", enabled: true, backendMode: "None" }, 
    { name: "staging", backendUrl: "https://staging.register-trainee-teachers.service.gov.uk", visibility: "Internal", enabled: true, backendMode: "None" }, 
    { name: "live", backendUrl: "https://www.register-trainee-teachers.service.gov.uk", visibility: "Public", enabled: true, backendMode: "None" }, 

  ], 
  releases: releases, 
  schema: { 
    fileName: "<schema_file_name>", 
    name: "<current_version>", 
    schemaType: "openapi", 
    contentType: "application/yaml", 
    documentContentValue: <base_64_encoded_schema_content>, 
  }, 
} 
```

NOTE:  

 Users who wish to manage APIs via a manifest can gather their "Automation Token" from their workspace and attach it to requests to the FaUAPI API as a Bearer token.  

### Manifest Field Descriptions 

|   |   |
|---|---|
|Field|Purpose|
|name|Unique identifier for the API within FaUAPI.|
|displayName|Human-readable name shown in the API catalogue.|
|description|Summary of the API and its purpose.|
|overview|Additional API information displayed to consumers.|
|siteUrl|URL for external API documentation.|
|backendType|Backend technology type, typically http.|
|majorVersion|Current major API version.|
|visibility|Visibility of the API, for example Public or Internal.|
|tags|Search keywords and categorisation tags.|
|classification|Business classification of the API.|
|serviceLevel|Expected service availability.|
|technology|Technology stack used by the API.|
|usage|Intended API consumers.|
|environments|Available deployment environments.|
|releases|API release metadata.|
|schema|OpenAPI specification and schema metadata.|

Important: 

The manifest structure may evolve over time. Always validate generated manifests against the current FaUAPI Automation API Schema before publication. 

### Generating the Manifest 

For most services, the FaUAPI manifest should not be maintained manually. 

Instead, it should be generated automatically from the service source code or deployment configuration. 

This approach reduces duplication and helps ensure that FaUAPI documentation remains aligned with the deployed service. 

## Automating FaUAPI Publication 

The preferred approach is to automate updates to FaUAPI wherever practical. 

Automation helps ensure that API documentation remains aligned with the deployed service and reduces the need for manual maintenance. 

FaUAPI does not require a specific automation approach. Teams should select the mechanism that best fits their service architecture and delivery processes. 

Possible approaches include: 
- CI/CD deployment pipelines 
- Scheduled jobs or cron jobs 
- Service background jobs 
- Release automation workflows 
- Manual publication processes 

The key requirement is that the API metadata and OpenAPI specification published within FaUAPI remain accurate and up to date. 

### Example Automation Flow 

Regardless of the implementation technology, the overall process is typically: 

Generate OpenAPI Specification  
	 │  
	▼  
Generate FaUAPI Manifest  
	 │  
	▼  
Validate Manifest  
	 │  
	▼  
Call FaUAPI Automation APIs  
	 │  
	▼  
Update FaUAPI  
	 │  
	▼  
Publish Updated Documentation 

### Reference Implementation 

The Register service provides an example of an automated FaUAPI integration. 

The current implementation uses scheduled background jobs rather than deployment-pipeline automation. 

Exemplary Ruby implementation 

https://github.com/DFE-Digital/register-trainee-teachers/tree/main/app/jobs/find_and_use_an_api 

https://github.com/DFE-Digital/register-trainee-teachers/tree/main/app/services/find_and_use_an_api 

https://github.com/DFE-Digital/register-trainee-teachers/tree/main/app/lib/find_and_use_an_api 

Manifest Generation 

https://github.com/DFE-Digital/register-trainee-teachers/tree/main/app/services/find_and_use_an_api/ build_manifests.rb 

The Register implementation should be viewed as an example service implementation rather than a prescribed approach.