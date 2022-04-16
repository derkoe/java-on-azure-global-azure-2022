#!/usr/bin/env bash

FUNCAPPNAME=`az deployment group create --resource-group=$1 --name azure-functions --template-file azure-functions.bicep --query properties.outputs.functionAppName.value`

func azure functionapp publish $FUNCAPPNAME

