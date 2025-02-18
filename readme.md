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