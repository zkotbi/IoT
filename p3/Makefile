CLUSTER_NAME ?= dev-cluster
NAMESPACE ?= argocd

all: create-cluster install-argocd wait credentials

create-cluster:
	@k3d cluster create $(CLUSTER_NAME) \
		-p "443:443@loadbalancer" \
		-p "80:80@loadbalancer" \
		--agents 2

install-argocd:
	@kubectl apply --server-side -k argocd/

wait: 
	@echo "waiting for argo to be up"
	@kubectl wait --for=condition=Available deployment --all -n $(NAMESPACE) --timeout=500s
	@kubectl apply -f application.yaml

credentials:
	@echo ""
	@echo "=================================================="
	@echo " Setup Complete!"
	@echo "=================================================="
	@echo "Password: $$(kubectl get secret argocd-initial-admin-secret -n $(NAMESPACE) -o jsonpath='{.data.password}' | base64 -d)"
	@echo "Username: admin"
	@echo ""
	@echo "Port forward to access UI:"
	@echo "  kubectl port-forward svc/argocd-server -n $(NAMESPACE) 8080:443"
	@echo "=================================================="

clean: 
	@k3d cluster delete $(CLUSTER_NAME)
