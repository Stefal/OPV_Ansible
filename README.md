# OPV_Ansible

This playbook install all services of a CUL (postgres, airflow and OPV services). To use it you have to:
* Change the hosts file to specify on wich host you want to install a master and workers
* Change some parameters in group_vars/all to change password of postgres and some other stuff

## Use with lxc

If you want to deploy an developement environment you can make containers with lxc.
The `deployLXCdevContainers.sh` script allow you to launch and configure 2 (one master and one worker) lxc containers.
This script will make the hosts file so you can skip next part !

```
./deployLXCdevContainers.sh
```

Next you will just have to launch ansible !

## The hosts file

The hosts file contain the ip and name of the master and all his workers. As we do not want to maintain a DNS on the CUL, we decided to populate the /etc/hosts file of the host with ansible, so you have to complete the host file as follow:

```
[ROLE]
HOSTNAME ansible_host=HOST_IP
```

Two possible roles:
* master: only one host can be the master
* worker: multiple hosts can be worker, **but they must have different hostname!**

**The first entry must be the correct hostname of the HOST !**

As example, imagine that we have 3 host: opv1, opv2 and opv3. We want the opv1 host to be our master and other as worker, so we complete the hosts file as follow:

```
[Master]
opv1 ansible_host=192.168.1.2

[Worker]
opv2 ansible_host=192.168.1.3
opv3 ansible_host=192.168.1.4
```


## The group_vars/all file

This file is use to precise some information as the password for database of airflow and OPV.

```
postgresPasswdAirflow: Testairflow42
postgresPasswdOPV: Testopv42
idMallette: POC
OPVMaster: OPV_Master
```

* postgresPasswdAirflow: The password of the postgresql database airflow
* postgresPasswdOPV: The password of the posgresql database opv
* idMallete: The id of the CUL you want to build
* OPV_Master: Just a way to set an alias to the master (use OPV_Master instead of the master's hostname)


# Launch the playbooks


## Install all dependencies

This playbooks will install all .deb package and all the stuff that need internet


```
./launch_install.sh
```

## Configure all component

This playbooks will:

* Stop anything that is running on the CUL (all services will be stop)
* Choose the Master
    * Start all services in it
    * Configure airflow and initialize database
    * Create OPV database
* Activate worker
    * Start worker on the host



```
./launch_configuration.sh
```

## Do both

To do the install and configure step as one, you can use:



```
./launch.sh
```
