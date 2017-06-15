#!/bin/bash

while [[ $# -gt 0 ]]; do
  key=$1

  case $key in
    --resource-group | -g)
      RESOURCE_GROUP_NAME="$2"
      shift
    ;;
    *)
      DEPLOYMENT="$1"
    ;;
  esac

  shift
done

if [ -z ${RESOURCE_GROUP_NAME+x} ]; then echo "Resource Group should be set with --resource-group or -g"; return 1; fi
if [ -z ${DEPLOYMENT+x} ]; then echo "Deployment should be indicated"; return 1; fi

cd "$DEPLOYMENT"

azure group create --tags 'billing=quantum' ${RESOURCE_GROUP_NAME} eastus2

azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  --resource-group ${RESOURCE_GROUP_NAME}

cd ..
