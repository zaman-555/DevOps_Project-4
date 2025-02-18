# Linux Network Namespace Simulation Assignment



## Prerequisites

Linux operating system
Root or sudo access
Packages

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install iproute2
sudo apt install net-tools

```

## Network Namespace Diagram

This diagram represents a network namespace setup, It using Linux containers or similar virtualization technologies. Let's break down the components and their relationships.

![Diagram](./images/diagram_1.png)

## Main Task

Create a network simulation with two separate networks connected via a router using Linux network namespaces and bridges.

## Create Network Bridges br0 and br1

Let's create two bridges which represent br0 and br1. Bridges act as virtual switchs, allowing multiple interfaces to be connected to the same network.

First open the terminal as the root user. I can write, 

```bash
sudo su -

```
make sure my possword is correct.

```bash
ip link add dev br0 type bridge
ip link add dev br1 type bridge

```

After creating the br0 and br1 let's check if it's create or not

```bash
ip link list

```
When i created a network interface, it's not automatically active. It exists in the system's configuration, but it's in "down" state. I need to explicitily bring it "up" to make it functional.

```bash
ip link set br0 up
ip link set br1 up

```
Let's check again if it now functional.

```bash
ip link list

```

## Create Network Namespace ns1, ns2 and router-ns

we will create three network namespace ns1, ns2 and router-ns. 

```bash
ip netns add ns1
ip netns add ns2
ip netns add router-ns

```
Let's check again if it created a three namespace.

```bash
ip netns list

```

## Create four virtual Ethernet pairs

```bash
ip link add veth-ns1 type veth peer name veth-br0
ip link add veth-ns2 type veth peer name veth-br1
ip link add veth-rns1 type veth peer name veth-br0-rns1
ip link add veth-rns2 type veth peer name veth-br1-rns2

```
Let's check again if it's created four new veth pairs.

```bash
ip netns list

```

## Connect virtual Ethernet pairs with bridge and namespace

```bash
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2
ip link set veth-rns1 netns router-ns
ip link set veth-rns2 netns router-ns
ip link set veth-br0 master br0
ip link set veth-br1 master br1
ip link set veth-br0-rns1 master br0
ip link set veth-br1-rns2 master br1

```
So far we run all the commands on root namespace, from root name if we run 

```bash
ip netns list

```
we can see br0 br1, and veth interface.