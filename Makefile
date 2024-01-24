CELLXGENE_DEMO_DIR := '/tmp/cellxgene_data'
DEMO_FILE := 'https://github.com/chanzuckerberg/cellxgene/raw/main/example-dataset/pbmc3k.h5ad'

prepare:
	@test -d $(CELLXGENE_DEMO_DIR) && mkdir -p $(CELLXGENE_DEMO_DIR)
	@test -e $(CELLXGENE_DEMO_DIR)/pbmc3k.h5ad || wget -O $(CELLXGENE_DEMO_DIR)/pbmc3k.h5ad $(DEMO_FILE)
	docker build -t cellxgene-proxy-local proxy
	docker build -t cellxgene-gateway cellxgene_gateway
	docker compose up
run:
	docker compose up -d

stop:
	docker compose stop

.PHONY: clean
clean:
	@echo "removing containers"
	docker compose down
