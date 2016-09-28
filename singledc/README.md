#Datastax Enterprise - Socialmetrix Deploy


## Creating Machines

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


## Cluster configuration

```bash
azure vm list "datastax" --json > /tmp/rg-datastax.json

```



## Destroy everything

1. If you need to delete the Resource Group:

```bash
azure group delete datastax
```
