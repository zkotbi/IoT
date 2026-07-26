#!/bin/bash
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
