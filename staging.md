### Create resource group

```
# dse-staging is the resource group, 'datacenter' is the type of resource we are creating
~/src/azure-resource-manager-dse(feature/managed_disks)$ ./deploy.sh datacenter -g dse-staging
```
```
info:    Executing command group create
+ Getting resource group dse-staging                                           
+ Updating resource group dse-staging                                          
info:    Updated resource group dse-staging
data:    Id:                  /subscriptions/245bb140-6c3a-4c2c-a17c-fdd104ceb8b8/resourceGroups/dse-staging
data:    Name:                dse-staging
data:    Location:            eastus2
data:    Provisioning State:  Succeeded
data:    Tags: billing=quantum
data:    
info:    group create command OK
info:    Executing command group deployment create
+ Initializing template configurations and parameters                          
+ Creating a deployment                                                        
info:    Created template deployment "mainTemplate"
+ Waiting for deployment to complete                 
+                                                                              
+                                                                              
info:    Resource 'nodes' of type 'Microsoft.Resources/deployments' provisioning status is Running
info:    Resource 'staging' of type 'Microsoft.Compute/availabilitySets' provisioning status is Succeeded
info:    Resource 'staging1' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging2' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging3' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'smxstagingstorage' of type 'Microsoft.Storage/storageAccounts' provisioning status is Running
+                                                                              
info:    Resource 'nodes' of type 'Microsoft.Resources/deployments' provisioning status is Running
info:    Resource 'staging' of type 'Microsoft.Compute/availabilitySets' provisioning status is Succeeded
info:    Resource 'staging1' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging2' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging3' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'smxstagingstorage' of type 'Microsoft.Storage/storageAccounts' provisioning status is Running
+                                                                              
info:    Resource 'nodes' of type 'Microsoft.Resources/deployments' provisioning status is Running
info:    Resource 'staging' of type 'Microsoft.Compute/availabilitySets' provisioning status is Succeeded
info:    Resource 'staging1' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging2' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'staging3' of type 'Microsoft.Network/networkInterfaces' provisioning status is Succeeded
info:    Resource 'smxstagingstorage' of type 'Microsoft.Storage/storageAccounts' provisioning status is Running
(...)
```

### Copy ssh keys to new machines
```
smx@deploy ~$ seq 1 3 | xargs -P 3 -I% ssh staging% 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvTckd8VEmBVMNOBIhIg1ez3zNEO2GJLea9gTsN8PcCaYUBZn3DCjTCkErS0Fmw4aQDzUHAVRWDkBD8++bCx2R6+qj+mMBQg7BaAIQ8v9z5T3va/tiDal9GyWZ+Fg+A4G13qU7CfSYXrDIDAciDe6+WQtGyuvRtGijODWyj1oiMRKazdVBIoZq7BbfBMdoOUlnmhYcJzTgi77tugtCvObtbAA70HQixrL2DHZFez60Dt/Qol1hl+fC4hSZ20G+BDx+ephj+RaderMjPdN03pF9lbVBovYmXaK7H8TGdelWhmBeITjjiyKEK9egXu66mMoRBeyFrhBdh4APMYLRJvbj ddellera@socialmetrix.com" >> ~/.ssh/authorized_keys'
seq 1 3 | xargs -P 3 -I% ssh staging% 'df |grep datadrive'
```

### Run ansible
```
~/src/devops-ansible(develop)$ ansible-playbook /home/smx/devops-ansible/pb-dse-staging.yml --tags bootstrap-analytics --limit staging1

smx@staging1:~$ sudo service dse start
smx@staging2:~$ sudo service dse start
smx@staging3:~$ sudo service dse start
```

### Create user/password
```
smx@staging1:~$ cqlsh -u cassandra -p cassandra
cassandra@cqlsh> CREATE ROLE smx WITH LOGIN=true AND PASSWORD = 'root@121c60df0c03083d2693c251f15fdfb2' AND SUPERUSER = true;
smx@staging1:~$ cqlsh -u $DSE_USERNAME -p $DSE_PASSWORD
DROP ROLE cassandra;
```

```
smx@staging1:~$ less /etc/dse/cassandra/cassandra.yaml encontrar seeds para setear "new cluster -> manage existing cluster" en opscenter
agregar pk de smx (sacar de deploy:~/.ssh/config/id_rsa, la privada)

smx@cqlsh> select * from system_schema.keyspaces;

 keyspace_name      | durable_writes | replication
--------------------+----------------+-------------------------------------------------------------------------------------
        system_auth |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
      system_schema |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
         dse_system |           True |                        {'class': 'org.apache.cassandra.locator.EverywhereStrategy'}
         dse_leases |           True |   {'Staging': '1', 'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy'}
       spark_system |           True |   {'Staging': '1', 'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy'}
      HiveMetaStore |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
          OpsCenter |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
 system_distributed |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '3'}
             system |           True |                             {'class': 'org.apache.cassandra.locator.LocalStrategy'}
        cfs_archive |           True |   {'Staging': '1', 'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy'}
           dse_perf |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
      system_traces |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '2'}
                cfs |           True |   {'Staging': '1', 'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy'}
       dse_security |           True | {'class': 'org.apache.cassandra.locator.SimpleStrategy', 'replication_factor': '1'}
      dsefs_staging |           True |   {'Staging': '1', 'class': 'org.apache.cassandra.locator.NetworkTopologyStrategy'}

(15 rows)
```

### Update RF (replication factor) and NT (network topology strategies)
```
ALTER KEYSPACE spark_system WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE dse_security WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE "OpsCenter" WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE dse_leases WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE dsefs_staging WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE cfs_archive WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE dse_perf WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE "HiveMetaStore" WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE cfs WITH replication = {'class': 'NetworkTopologyStrategy', 'Staging': '3'};
ALTER KEYSPACE dse_system WITH replication = {'class': 'EverywhereStrategy'};
```

### Check status
```
smx@staging1:~$ nodetool -u $DSE_USERNAME -pw $DSE_PASSWORD status

Datacenter: Staging
===================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address       Load       Tokens       Owns    Host ID                               Rack
UN  10.3.245.103  407.97 KiB  128          ?       fba6555d-129b-47aa-90a3-b7732799a999  fd0
UN  10.3.245.102  191.19 KiB  128          ?       b57cf699-190a-461a-8824-f3dc8926c6b7  fd0
UN  10.3.245.101  193.18 KiB  128          ?       93b1880c-75a1-4e9a-8e65-7536ffaaf6b1  fd0

(UN = up, normal)

# where are they?
smx@staging1:~$ less /etc/dse/cassandra/cassandra-rackdc.properties
```

### Create Spark & Spark events folders
```
dse hadoop fs -mkdir /spark && dse hadoop fs -mkdir /spark/events
```

### Increase agent memory
```
# python2 required
/usr/local/bin/ansible-role opscenter-agent -b -H staging # 'staging' defines new machines in the inventory
deploy: seq 1 3 | xargs -P 3 -I% ssh staging% 'sudo service datastax-agent restart'
```

## Deploy app
```
deploy {master} ~/code/ananke-spark$ git pull && source sbin/ananke-spark-functions && deploy-all --no-rebuild staging1 staging2 staging3
```

### Enable cron jobs
Copy /etc/cron.d/ananke-jobs to staging1 via scp.

## Copy Geoloc index
```
seq 1 3 | xargs -P 3 -I% scp lib/geoloc/index/* staging%:/opt/smx/ananke/lib/geoloc/index/
```
