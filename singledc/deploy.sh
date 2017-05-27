#!/bin/sh

DATACENTER_NAME=rationale

azure group create --tags 'billing=quantum' ${DATACENTER_NAME} eastus2

azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  ${DATACENTER_NAME} ${DATACENTER_NAME}