# Murano Core Load Test Template

This project includes a setup for running various load tests on Murano.

## Setup

This project is a Murano template and can be passed upon solution creation which will setup all endpoints.
You then need to save the domain name of the solution api and pass it as Jenkins parameter or update the Jenkinsfile default value.

## Jenkins load test

This project contains the setup for daily run job.

- ./murano.jmx contains the JMeter config
- ./Dockerfile contains the basic JMeter image
- ./test-docker-compose.yaml setup the JMeter image and run the tests
- ./Jenkinsfile setup the test flow

Setup Jenkins to discover the jenkinsfile and will auto-setup automatically.

Current setup: https://jenkins.exosite.com/job/Murano/job/Murano_benchmark/

**Note:** This requires the Jenkins Performance plugin (https://www.blazemeter.com/blog/how-to-use-the-jenkins-performance-plugin)

### Test suite

Current test includes:

- hello world
- keystore command
- tsdb write

## External access

End-to-End test of Murano Solution through the public custom API.

*URL:* GET https://<solution domain>.apps.exosite.com/<path>
or
*URL:* POST https://<solution domain>.apps.exosite.com/<path>
*Payload:*
```application/json
<service call arguments>
```
*Note:*
* Only http (1.1) is supported

For path & parameters see [./endpoints/load.lua](./endpoints/load.lua)

## Internal access

Internal test by-passing edge service and directly calling Murano-Core components: Pegasus-Dispatcher or Pegasus-Engine

### From Pegasus-Dispatcher

*URL:* POST http://pegasus-dispatcher:4000/api/v1/trigger/<solution id>/scripts/<event>
*Payload:*
```application/json
{
  <event parameters>
}
```

*Note:*
* Both http or http2 are supported

For event & payload content see [./services/scripts.lua](./services/scripts.lua)

### From Pegasus-Engine

*URL:* POST http://pegasus-engine:5000/execute/<solution id>/scripts_<event>
*Payload:*
```application/json
{
  <event parameters>
}
```

*Note:*
* Both http or http2 are supported

For event & payload content see [./services/scripts.lua](./services/scripts.lua)
