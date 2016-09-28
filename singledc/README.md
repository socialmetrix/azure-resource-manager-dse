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

1. Open [Datastax Lifecycle Manager](http://smxopscenter-ip.eastus2.cloudapp.azure.com:8888/opscenter/lcm.html) and configure your cluster

1. To obtain a list of all nodes you can use this command:

```bash
azure network nic list "datastax" --json > /tmp/datastax-nic.json
cat /tmp/datastax-nic.json | jq -r '.[] | [.name, .ipConfigurations[].privateIPAddress] | @csv' | sort
```


## Destroy everything

1. If you need to delete the Resource Group:

```bash
azure group delete -q datastax
```
