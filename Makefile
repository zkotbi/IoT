p1:
	cd p1 && vagrant up

destroy-p1:
	cd p1 && vagrant destroy -f

ssh-server:
	cd p1 && vagrant ssh server

ssh-worker:
	cd p1 && vagrant ssh worker
