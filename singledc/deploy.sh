#!/bin/sh

RESOURCE_GROUP_NAME=dse-staging
DATACENTER_NAME=analytics

azure group create --tags 'billing=quantum' ${RESOURCE_GROUP_NAME} eastus2

azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  ${RESOURCE_GROUP_NAME} ${DATACENTER_NAME}
