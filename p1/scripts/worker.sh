#!/bin/bash

WORKER_IP=192.168.56.111
CONTROLE_PLANE_IP=192.168.56.110

curl -sfL https://get.k3s.io | K3S_URL="https://$CONTROLE_PLANE_IP:6443" \
    INSTALL_K3S_EXEC="agent --node-ip=$WORKER_IP --flannel-iface=eth1" sh -s -

