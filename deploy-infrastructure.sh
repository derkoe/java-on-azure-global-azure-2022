#!/usr/bin/env bash
set -euo pipefail

az deployment group create --resource-group=rg-java-on-azure --name java-on-azure --template-file java-on-azure.bicep
