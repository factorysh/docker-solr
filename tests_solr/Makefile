UID=$(shell id -u)
SOLR_VERSION := ""
BASE_URL :=""

tests:
	rm -rf ./test_tmp
	mkdir -p  ./test_tmp
	@echo "\n"
	@echo "========== Testing Solr $(SOLR_VERSION) on url $(BASE_URL) =========="
	@docker-compose down || true
	@SOLR_VERSION=$(SOLR_VERSION) BASE_URL=$(BASE_URL) UID=$(UID) docker-compose up --build -d solr
	sleep 2
	@SOLR_VERSION=$(SOLR_VERSION) BASE_URL=$(BASE_URL) docker-compose up --abort-on-container-exit --exit-code-from client client
	@docker-compose down || true
	rm -rf ./test_tmp

down:
	@docker-compose down || true
