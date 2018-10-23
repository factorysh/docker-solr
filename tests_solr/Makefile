SOLR_VERSION := ""
TEST_URL :=""

tests:
	@echo "\n"
	@echo "========== Testing Solr $(SOLR_VERSION) on url $(TEST_URL) =========="
	@docker-compose down || true
	@SOLR_VERSION=$(SOLR_VERSION) TEST_URL=$(TEST_URL) docker-compose up -d solr
	sleep 2
	@docker-compose up --abort-on-container-exit --exit-code-from client client
	@docker-compose down || true
