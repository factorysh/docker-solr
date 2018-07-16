
GOSS_VERSION := 0.3.5

all: solr3

solr3:
	docker build -t bearstech/solr:3 -f Dockerfile.36 .
	docker tag bearstech/solr:3 bearstech/solr:3.6
	docker tag bearstech/solr:3 bearstech/solr:latest

pull:
	docker pull bearstech/debian:stretch

push:
	docker push bearstech/solr:3
	docker push bearstech/solr:3.6
	docker push bearstech/solr:latest

bin/goss:
	mkdir -p bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

test: bin/goss
	@docker-compose -f tests/docker-compose.yml down || true
	@docker-compose -f tests/docker-compose.yml up -d
	@docker-compose -f tests/docker-compose.yml exec goss \
		goss -g solr.yaml validate --max-concurrent 4 --format documentation
	@docker-compose -f tests/docker-compose.yml down || true

tests: test
