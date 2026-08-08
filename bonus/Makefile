CLUSTER_NAME = dev-cluster

all: create-cluster install-gitlab

create-cluster:
	@k3d cluster create $(CLUSTER_NAME) \
		-p "443:443@loadbalancer" \
		-p "80:80@loadbalancer" \
		--agents 2

install-gitlab:
	@kubectl apply -k gitlab/

clean: 
	@k3d cluster delete $(CLUSTER_NAME)


