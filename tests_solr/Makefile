SOLR_VERSION := ""

tests:
	@echo "Testing solr $(SOLR_VERSION) =========="
	@docker-compose down || true
	@SOLR_VERSION=$(SOLR_VERSION) docker-compose up -d solr
	sleep 2
	@docker-compose up --abort-on-container-exit --exit-code-from client client
	@docker-compose down || true
