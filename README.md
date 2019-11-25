
# Cloud2Murano Murano Product

This project is a template of Murano Product for 3rd party integration providing connectivity to the devices.

As each cloud integration has its particularity, this project requires modification to fit the 3rd party setup and not a generic plug&play solution.

### Implementation example

Some example of 3rd party integration based on this template.

- openweathermap.org : https://github.com/exosite/getting-started-solution-template/tree/open-weather-product

### Setup

Following customization steps are required to accomplish the integration.

1. [Add the 3rd party API as Murano service](add-the-3rd-party-api-as-murano-service)
  1. [Define the OpenApi Swagger](define-the-openapi-swagger)
  1. [Publish it on the Exchange Marketplace](publish-it-on-the-exchange-marketplace)
1. [Update the Template project](update-the-template-project)
  1. [Publish the Cloud integration template](publish-the-cloud-integration-template)
1. [Customization](customization)
  1. [Setup for ExoSense](setup-for-exoSense)
  1. [IoT-Connector integration](iot-connector-integration)
1. [Known limitations](known-limitations)

---

### Add the 3rd party API as Murano service

This section is to enable Murano to connect to an interact with the 3rd party cloud.
If you intend to only support incoming callbacks, you can ignore this section.

Once the below steps are ready, add a new configuration file ./services/<CloudServiceName>.yaml in this template.

##### Define the OpenApi Swagger

First you need to define the 3rd party service API using the OpenApi swagger definition.
You can follow the general documentation from https://github.com/exosite/open_api_integration.
But also follow the guidelines from the example available on this project in ./<CloudServiceSwagger>.yaml .

For example this sample assumes the use of a `token` parameter for authentication to the 3rd party.

##### Publish it on the Exchange Marketplace

Publish the service swagger on Murano Exchange IoT marketplace (http://docs.exosite.com/reference/ui/exchange/authoring-elements-guide/) and test your integration with a blank Murano solution.

Once ready publish the service as 'Public' so it can be used. (This action is currently limited so you might need to contact Exosite support).

---

### Update the Template project

This project now need to be adapted for the 3rd party connectivity needs.

Before getting started: to be compatible with IoT connector (PDaaS) for a later integration follow:
- Use the `c2c` namespacing for Modules, Endpoints, Assets and any stored items to avoid potential naming conflict
- Avoid adding code in eventhandlers as it will make the merging harder, instead put your code in Modules
- Make clear commits so you can easily rebase on future updated version of this base template

**1. Clone this repository**

**2. Update this project with the newly created service**

Update `<CloudServiceName>` by the actual service alias you used to publish the service on Murano IoT marketplace.
Important in Lua, service starts with a Capital letter.

If not done yet create a configuration file under [./service/<CloudServiceName>.yaml](./service/<CloudServiceName>.yaml) containing the service fixed settings. If all configuration need to be provided by the users, leave the file blank.

**3. Modify the callback authentication logic**

This sample assumes a single callback endpoint for each event defined in [endpoints/c2c/callbacks.lua](endpoints/c2c/callbacks.lua) & [modules/c2c/authentication.lua](modules/c2c/authentication.lua).
We use a token generated at solution bootstrap & passed as query parameter to authenticate the 3rd party.
Other authentication system can be defined there.

**4. Modify the data structure mapping logic**

2 modules are used for data mapping with the 3rd service.

[modules/c2c/cloud2murano.lua](modules/c2c/cloud2murano.lua) for incoming messages.
This files parse & dispatches the data coming from the 3rd party to Murano device state service and to the applications.
You need to modify this file to match the 3rd party events for device provisioning, deletion and incoming sensor data.

[modules/c2c/murano2cloud.lua](modules/c2c/murano2cloud.lua) for outgoing messages.
The payload structure needed in this files depends on the the swagger definition of the service.

**[5. Modify pooling logic] (Optional)**

If the 3rd party requires a regular pooling syncronisation, you need to enable the internal in the ./services/timer.yaml config.
The default logic set in the [services/timer_timer.lua](services/timer_timer.lua) eventhandler will use the same structure as for callbacks.

#### Publish the Cloud integration template

Once the project setup is ready and updated on your repository.
You can test it by creating a new product `From scratch` on the Murano solution page and provide your git repo url.

Find more about Murano template on https://github.com/exosite/getting-started-solution-template.

Once satisfied you will need to publish a Template element on Murano IoT marketplace (http://docs.exosite.com/reference/ui/exchange/authoring-elements-guide/).

**Consumer flow: how to use the template in murano**
1. User go to Murano IoT marketplace select your integration template & click create solution.
1. User go to the newly created product management page under `Services -> <CloudServiceName>` and add the required settings & credentials as defined by your 3rd party service Swagger.
1. (Optional) If callback setup is not automated, user copy/past the callback url from there and add it to the 3rd party setup.
1. The product is then ready to use and can be added to any Murano applications as a regular product.

---

### Customization

You can also provide some tooling for the template user to extend your integration.
While you want to be able to provide new version of your template you need to avoid erasing some of the template user changes.
For this purpose we defines a `safeNamespace` for the user (in [murano.yaml](murano.yaml)) every items (modules, endpoints & assets) start with this name will not be remove nor modified by template updates.

User can then safely modify the [modules/vendor/c2c/transform.lua](modules/vendor/c2c/transform.lua) to change the data mapping or even add new public APIs (under `/vendor/*`) to extend the product capability.

If the user don't want to get update, automated updates can be deactivated on the Product `Services -> Config` settings.

_IMPORTANT_: To get persistent product state, related resources needs to be defined in the device2 service resources.
While editor of this template can change the default setup in [services/device2.yaml](services/device2.yaml) (default setup for Exosense compatibility) are needed by the user from the Product page under `Resources` all resources must have the option `sync` set to `false`!

#### Setup for ExoSense

ExoSense application datamodel nest device data into the 'data_in' product resource of type JSON.
In order to be utilized from exosense the 'data_in' content structure, named channels, have to be described in the 'config_io' resource.

The device2 data structure set in [services/device2.yaml](services/device2.yaml) is already Exosense compatible.
However template user needs to update the product [modules/vendor/configIO.lua](modules/vendor/configIO.lua) Module and updates the data structure specific to the product.

#### IoT-Connector integration

This template can be extended as an IoT Connector (PDaaS) to provide & publish product instance to multiple internal and external applications.

Assuming you have a workable 3rd party cloud integrated and followed the above `setup` section.
1. Create a new branch or repo to keep the stand-alone version
1. Clone the Iot Connector (https://github.com/exosite/pdaas_template) repository
1. Merge Modules, Assets & endpoints: Different namespaces are used and you should be able to copy all modules files into your project modules.
1. Merge Services: Overlapping service configuration & eventhandlers needs to be merged manually, luckily the logic is trivial
1. Merge init.lua & murano.yaml: No changes from PDaaS should be required, however you need to enable the 'Assets' options
1. Push your changes to the PDaaS-Cloud2Cloud product branch
1. Publish the new template to Murano Exchange as described above

---

### Known limitations

- As external service don't have an event API, current version requires the webservice to add custom routes for callback. (MUR-9171)
- If the 3rd party api requires signature header, the signature management needs to be done in Lua.
- Device2 service doesn't support batch functionality yet.
- Exosense `config_io` is fixed (in [modules/vendor/configIO.lua](modules/vendor/configIO.lua)) and cannot be modified per device.
