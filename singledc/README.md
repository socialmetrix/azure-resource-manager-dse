#Datastax Enterprise - Socialmetrix Deploy

1. Login to Azure:

```bash
azure login
```

1. Create a Resource Group:

```bash
azure group create --tags 'billing=quantum' datastax eastus2
```

1. Execute the template:

```bash
azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  datastax datastax
```

1. If you need to delete the Resource Group:

```bash
azure group delete datastax
```
