#Datastax Enterprise - Socialmetrix Deploy
This is our current deploy template. Differences from official DSE are:

- It creates 6 node machines, [edit here to change](https://github.com/socialmetrix/azure-resource-manager-dse/blob/feature/socialmetrix/singledc/mainTemplateParameters.json#L3)
- Each machine has a 1Tb Premium Storage attached
- Networking is on a different Resource Group
- Better naming convention and static IP assignment, following the rule:

| VM name | IP |
| --- | --- |
| opscenter | 10.3.15.5 |
| dc1vm0 | 10.3.15.100 |
| dc1vm1 | 10.3.15.101 |
| dc1vm2 | 10.3.15.102 |
| dc1vm3 | 10.3.15.103 |
| dc1vm4 | 10.3.15.104 |
| dc1vm5 | 10.3.15.105 |


## Creating Machines

1. Login to Azure:

```bash
azure login
```

1. Create a **Resource Group**:

```bash
azure group create --tags 'billing=quantum' dse eastus2
```

1. Execute the template:

```bash
azure group deployment create \
  --template-file mainTemplate.json \
  --parameters-file mainTemplateParameters.json \
  dse dse
```

## Cluster configuration

1. Login to **OpsCenter VM** and install it:
These instructions follows official DSE docs [Installing OpsCenter from the Debian package](http://docs.datastax.com/en/opscenter/6.0/opsc/install/opscInstallDeb_t.html)

```bash
sudo su

DSA_EMAIL=xxxxxx
DSA_PASSWORD=xxxxxx

echo "deb https://${DSA_EMAIL}:${DSA_PASSWORD}@debian.datastax.com/enterprise stable main" | sudo tee /etc/apt/sources.list.d/datastax.sources.list

curl -L https://debian.datastax.com/debian/repo_key | sudo apt-key add -

apt-get update
apt-get install -y opscenter htop sysstat

service opscenterd start
```

*On my setup it **tooks several minutes** to OpsCenter start answering HTTP requests, be patient!*

1. Open [Datastax Lifecycle Manager](http://smxopscenter.eastus2.cloudapp.azure.com:8888/opscenter/lcm.html) and configure your cluster

1. To obtain a list of all nodes you can use this command:

```bash
azure network nic list "dse" --json > /tmp/dse-nic.json
cat /tmp/dse-nic.json | jq -r '.[] | [.name, .ipConfigurations[].privateIPAddress] | @csv' | sort
```

1. Set **vnodes** to 128 for **Spark**, as [described here](https://docs.datastax.com/en/datastax_enterprise/5.0/datastax_enterprise/config/configVnodes.html)

## Enable User Authentication 
[Reference](https://docs.datastax.com/en/opscenter/6.0/opsc/configure/opscEnablingAuth.html):

```
# /etc/opscenter/opscenterd.conf

[authentication]
enabled=True
```

## Destroy everything

1. If you need to delete the resource group and all its content:

```bash
azure group delete -q dse
```
