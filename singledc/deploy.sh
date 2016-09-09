#!/bin/sh

azure group create --tags 'billing=quantum' datastax eastus2

azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  datastax datastax