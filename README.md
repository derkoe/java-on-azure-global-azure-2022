# Java on Azure - Global Azure 2022

This repository contains all demos shown in my talk "Java on Azure" at the "Global Azure 2022" conference.

## Deploy Infrastructure

You'll find the script to deploy the infrastructure in: [java-on-azure.bicep](java-on-azure.bicep).

To deploy this to your Azure account [get the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and create a resource group named `rg-java-on-azure`. Then run:

```bash
./deploy-infrastructure.sh
```

## Build Example App

To build the example app install Java and [Maven](https://maven.apache.org/) then build the app in the `java-realworld-app` folder:

```bash
mvn package spring-boot:build-image
```

## Deploy Webapp

After building the app run:

```bash
./deploy-webapp.sh
```

## Deploy Function App

To deploy the function you'll have to create a GraalVM native-image of the application first. Un the `java-realworld-app` folder run:

```
mvn -Pnative spring-boot:build-image
```

Then copy the binary out of the docker image to the functions folder and run:

```
./deploy-function.sh
```
