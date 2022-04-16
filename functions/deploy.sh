#!/usr/bin/env bash
set -euo pipefail

FUNCAPPNAME=$(az deployment group create --resource-group=$1 --name azure-functions --template-file azure-functions.bicep --query properties.outputs --output json | jq -r .functionAppName.value)

func azure functionapp publish $FUNCAPPNAME
