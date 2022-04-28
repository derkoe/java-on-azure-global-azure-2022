#!/usr/bin/env bash
set -euo pipefail

pushd functions
FUNCAPPNAME=$(az functionapp list --resource-group rg-java-on-azure -o json | jq -r '.[] | .name')
func azure functionapp publish $FUNCAPPNAME
popd
