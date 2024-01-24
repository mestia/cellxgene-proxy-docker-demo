build:
	docker build -t cellxgene-proxy-local proxy
	docker build -t cellxgene-gateway cellxgene_gateway
	docker compose up
run:
	docker compose up -d

stop:
	docker compose down

.PHONY: clean
clean:
	@echo "removing containers"
	docker container rm openldap-local cellxgene-grp1 cellxgene-public cellxgene-apache2-proxy cellxgene-grp2

