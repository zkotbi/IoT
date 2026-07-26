#!/bin/bash
set -e

curl -sfL https://get.k3s.io | sh -

chmod 644 /etc/rancher/k3s/k3s.yaml

##/vagrant/scripts/wait.sh
# WAITING 
set -e

echo "[INFO] Waiting for K3s..."

until kubectl get nodes >/dev/null 2>&1
do
    sleep 2
done

until kubectl get nodes | grep -q Ready
do
    sleep 2
done

echo "[INFO] Cluster Ready"

kubectl get nodes

kubectl apply -k /vagrant
