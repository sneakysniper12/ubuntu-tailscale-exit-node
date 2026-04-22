#!/bin/bash
set -e

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

grep -qxF 'net.ipv4.ip_forward=1' /etc/sysctl.conf || \
  echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf

grep -qxF 'net.ipv6.conf.all.forwarding=1' /etc/sysctl.conf || \
  echo 'net.ipv6.conf.all.forwarding=1' | sudo tee -a /etc/sysctl.conf

