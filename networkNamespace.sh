#!/bin/bash

# Create netns namespace ns1 , ns2 and router-ns

ip netns add ns1
ip netns add ns2
ip netns add router-ns

# Create Bridges br0 and br1

ip link add br0 type bridge
ip addr add 10.11.0.1/16 dev br0
ip link set br0 up

ip link add br1 type bridge
ip addr add 10.12.0.1/16 dev br1
ip link set br1 up
 

# Peer A

ip link add veth-ns1 type veth peer name veth-br0
ip link set veth-br0 up 
ip link set veth-br0 master br0
ip link set veth-ns1 netns ns1
ip netns exec ns1 ip addr add 10.11.0.2/16 dev veth-ns1
ip netns exec ns1 ip link set veth-ns1 up

# Peer B

ip link add veth-br0-rns1 type veth peer name veth-rns1
ip link set veth-br0-rns1 up 
ip link set veth-br0-rns1 master br0
ip link set veth-rns1 netns router-ns
ip netns exec router-ns ip addr add 10.11.0.3/16 dev veth-rns1
ip netns exec router-ns ip link set veth-rns1 up

# Peer C

ip link add veth-rns2 type veth peer name veth-br1-rns2
ip link set veth-br1-rns2 up 
ip link set veth-br1-rns2 master br1
ip link set veth-rns2 netns router-ns
ip netns exec router-ns ip addr add 10.12.0.3/16 dev veth-rns2
ip netns exec router-ns ip link set veth-rns2 up

# Peer D

ip link add veth-ns2 type veth peer name veth-br1
ip link set veth-br1 up 
ip link set veth-br1 master br1
ip link set veth-ns2 netns ns2
ip netns exec ns2 ip addr add 10.12.0.2/16 dev veth-ns2
ip netns exec ns2 ip link set veth-ns2 up


sysctl -w net.ipv4.ip_forward=1 &> /dev/null

iptables --append FORWARD --in-interface br0 --jump ACCEPT
iptables --append FORWARD --out-interface br0 --jump ACCEPT

iptables --append FORWARD --in-interface br1 --jump ACCEPT
iptables --append FORWARD --out-interface br1 --jump ACCEPT

ip netns exec ns1 ip route add default via 10.11.0.3
ip netns exec ns2 ip route add default via 10.12.0.3

ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1 &> /dev/null
