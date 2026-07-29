#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
P3_DIR="$(dirname "$SCRIPT_DIR")"

echo "========== CLEAN =========="

k3d cluster delete iot >/dev/null 2>&1 || true

rm -f "$HOME/.kube/config"

echo "========== INSTALL KUBECTL =========="

if ! command -v kubectl >/dev/null 2>&1; then
    curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -m 755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

echo "========== INSTALL K3D =========="

if ! command -v k3d >/dev/null 2>&1; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

echo "========== CREATE CLUSTER =========="

k3d cluster create iot \
    --servers 1 \
    --agents 0 \
    -p "8888:80@loadbalancer"

export KUBECONFIG="$HOME/.kube/config"

echo "========== WAIT FOR CLUSTER =========="

kubectl wait \
    --for=condition=Ready \
    node/k3d-iot-server-0 \
    --timeout=300s

echo "========== CREATE NAMESPACES =========="

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -

echo "========== INSTALL ARGOCD =========="

kubectl apply \
    --server-side \
    -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "========== WAIT FOR ARGOCD =========="

kubectl rollout status \
    deployment/argocd-server \
    -n argocd \
    --timeout=300s

echo "========== CREATE APPLICATION =========="

kubectl apply -f "$P3_DIR/confs/application.yaml"

echo
echo "========== DONE =========="

kubectl get nodes
echo

kubectl get ns
echo

kubectl get applications -A
