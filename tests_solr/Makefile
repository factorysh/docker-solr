UID=$(shell id -u)
SOLR_VERSION := ""
BASE_URL :=""

tests:
	rm -rf ./test_tmp
	mkdir -p  ./test_tmp
	UID=$(UID) SOLR_VERSION=$(SOLR_VERSION) docker build -t tests/solr:$(SOLR_VERSION)  -f Dockerfile.solr --build-arg uid=$(UID) --build-arg solr_version=$(SOLR_VERSION) .
	@echo "\n"
	@echo "========== Testing Solr $(SOLR_VERSION) on url $(BASE_URL) =========="
	@docker-compose down || true
	@SOLR_VERSION=$(SOLR_VERSION) BASE_URL=$(BASE_URL) docker-compose up -d solr
	sleep 2
	@docker-compose up --abort-on-container-exit --exit-code-from client client
	@docker-compose down || true
	rm -rf ./test_tmp
