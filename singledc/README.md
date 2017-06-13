# Datastax Enterprise - Socialmetrix Deploy
This is our current deploy template. Differences from official DSE are:

- It creates n node machines, [edit here to change](https://github.com/socialmetrix/azure-resource-manager-dse/blob/feature/socialmetrix/singledc/mainTemplateParameters.json#L3)
- Each machine has a 1Tb Premium Storage attached
- Networking is on a different Resource Group
- Better naming convention and static IP assignment, following the rule:

| VM name | IP |
| --- | --- |
| [opscenterName] | 10.3.15.255 |
| [dcName]1 | 10.3.15.1 |
| [dcName]2 | 10.3.15.2 |
| [dcName]3 | 10.3.15.3 |
| [dcName]4 | 10.3.15.4 |
| [dcName]5 | 10.3.15.5 |


## Creating Machines

1. Login to Azure `azure login`.

2. Edit `mainTemplateParameters.json` to matches your needs.

3. Create a **SubNet** that matches `mainTemplateParameters.json`, eg: `rationale (10.3.50.0/24)`

4. Run the deploy script passing the **Resource Group**: `./deploy.sh <Resource Group>`



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
