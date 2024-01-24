TMP_DATADIR := $(shell mktemp -d)
container := ${CONTAINER}


build:
	docker build -t cellxgene-proxy-local proxy
	docker build -t cellxgene-gateway cellxgene_gateway
	docker compose up 

stop:
	docker compose stop

.PHONY: clean
clean:
	@echo "removing containers"
	docker container rm openldap-local cellxgene-grp1 cellxgene-public cellxgene-proxy-local

