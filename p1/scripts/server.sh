#!/bin/bash

CONTROLE_PLANE_IP=192.168.56.110

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=$CONTROLE_PLANE_IP --flannel-iface=eth1" sh -s -

