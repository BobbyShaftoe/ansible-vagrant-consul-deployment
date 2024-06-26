## Update - Custom Changes

> NOTE: There is some custom stuff on top of this
 - additional hosts have been added to the Vagrantfile
 - An existing base image was used for the machines (minimal/trusty64)
 - There's a public/private keypair specific to a local user being used here, until changes in the next point
 - The Ansible provisioner will be implemented, when actual services are added to these instances

The specific command used to initially provision the machines is now:
```
DEMO_BOX_NAME="minimal/trusty64" vagrant up
```

Subsequent changes that added hosts to the Vagrantfile were actioned with this command:
```
vagrant reload --provision
```


# Vagrant Consul Demo

This demo provides a very simple `Vagrantfile` that creates two Consul
server nodes, one at *172.20.20.10* and another at *172.20.20.11*. Both are
running a standard Debian * distribution, and Consul is pre-installed.

To get started, you can start the nodes by just doing:

```
vagrant up
```

> NOTE: If you prefer a different Vagrant box, you can set the `DEMO_BOX_NAME`
> environment variable before starting `vagrant` like this: 
> `DEMO_BOX_NAME="ubuntu/xenial64" vagrant up`

Once it is finished, you should be able to see the following:

```
vagrant status
Current machine states:

n1                        running (virtualbox)
n2                        running (virtualbox)
```

At this point the two nodes are running and you can SSH in to play with them:

```
vagrant ssh n1
consul version
Consul v0.7.2
Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
exit
```

and

```
vagrant ssh n2
consul version
Consul v0.7.2
Protocol 2 spoken by default, understands 2 to 3 (agent will automatically use protocol >2 when speaking to compatible agents)
exit
```

> NOTE: This demo will install the latest Consul release version by default,
> but if you prefer a different version, you can set the `CONSUL_DEMO_VERSION`
> environment variable before starting `vagrant` like this: 
> `CONSUL_DEMO_VERSION=0.6.4 vagrant up`

## Where to Next?

To learn more about starting Consul, joining nodes into a cluster, and
interacting with the agent, check out the [Getting Started guide](https://www.consul.io/intro/getting-started/install.html).
