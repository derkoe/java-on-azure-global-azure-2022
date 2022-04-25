#!/usr/bin/env bash
set -euo pipefail

JAVA_WEBAPP_NAME=`az webapp list --resource-group rg-java-on-azure -o json | jq -r '.[] | .name' | grep java`
az webapp deploy --resource-group  rg-java-on-azure --name $JAVA_WEBAPP_NAME --src-path java-realworld-app/target/java-realworld-app-0.0.1-SNAPSHOT.jar --type jar
