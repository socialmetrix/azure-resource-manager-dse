#Datastax Enterprise - Socialmetrix Deploy
This is our current deploy template. Differences from official DSE are:

- It creates 6 node machines, [edit here to change](https://github.com/socialmetrix/azure-resource-manager-dse/blob/feature/socialmetrix/singledc/mainTemplateParameters.json#L3)
- Each machine has a 1Tb Premium Storage attached
- Networking is on a different Resource Group
- Better naming convention and static IP assignment (10.3.150.x):

| VM name | IP |
| --- | --- |
| opscenter | 10.3.150.5 |
| dc0vm0 | 10.3.150.10 |
| dc0vm1 | 10.3.150.11 |
| dc0vm2 | 10.3.150.12 |
| dc0vm3 | 10.3.150.13 |
| dc0vm4 | 10.3.150.14 |
| dc0vm5 | 10.3.150.15 |


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

1. Login to **OpsCenter VM** and install it:
These instructions follows official DSE docs [Installing OpsCenter from the Debian package](http://docs.datastax.com/en/opscenter/6.0/opsc/install/opscInstallDeb_t.html)

```bash
DSA_EMAIL=xxxxxx
DSA_PASSWORD=xxxxxx

echo "deb https://${DSA_EMAIL}:${DSA_PASSWORD}@debian.datastax.com/enterprise stable main" | sudo tee /etc/apt/sources.list.d/datastax.sources.list

curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

apt-get update
apt-get install -y opscenter htop

service opscenterd start
```

*On my setup it **tooks several minutes** to OpsCenter start answering HTTP requests, be patient!*

1. Open [Datastax Lifecycle Manager](http://smxopscenter-ip.eastus2.cloudapp.azure.com:8888/opscenter/lcm.html) and configure your cluster

1. To obtain a list of all nodes you can use this command:

```bash
azure network nic list "datastax" --json > /tmp/datastax-nic.json
cat /tmp/datastax-nic.json | jq -r '.[] | [.name, .ipConfigurations[].privateIPAddress] | @csv' | sort
```

## Destroy everything

1. If you need to delete the resource group and all its content:

```bash
azure group delete -q datastax
```
