
GOSS_VERSION := 0.3.5

SOLR_URL=http://archive.apache.org/dist/lucene/solr
SOLR36_VERSION=3.6.2
SOLR49_VERSION=4.9.1
JETTY8_VERSION=8.1.10

all: pull build

build: solr3 solr4

build/jetty-$(JETTY8_VERSION)/jetty.tgz:
	# fetch archive
	mkdir -p build/jetty-$(JETTY8_VERSION)
	curl $(SOLR_URL)/$(SOLR49_VERSION)/solr-$(SOLR49_VERSION).tgz > build/jetty-$(JETTY8_VERSION)/jetty.tgz

build/jetty-$(JETTY8_VERSION)/jetty: build/jetty-$(JETTY8_VERSION)/jetty.tgz
	mkdir -p build/jetty-$(JETTY8_VERSION)/jetty
	#only extract jetty
	tar --strip-components=2 -C build/jetty-$(JETTY8_VERSION)/jetty \
      -xzf build/jetty-$(JETTY8_VERSION)/jetty.tgz solr-$(SOLR49_VERSION)/example/start.jar
	#extract jetty lib
	tar --strip-components=2 -C build/jetty-$(JETTY8_VERSION)/jetty \
      -xzf build/jetty-$(JETTY8_VERSION)/jetty.tgz solr-$(SOLR49_VERSION)/example/lib
	#extract jetty etc
	tar --strip-components=2 -C build/jetty-$(JETTY8_VERSION)/jetty \
      -xzf build/jetty-$(JETTY8_VERSION)/jetty.tgz solr-$(SOLR49_VERSION)/example/etc
	#extract jetty contexts
	tar --strip-components=2 -C build/jetty-$(JETTY8_VERSION)/jetty \
      -xzf build/jetty-$(JETTY8_VERSION)/jetty.tgz solr-$(SOLR49_VERSION)/example/contexts

build/$(SOLR36_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR36_VERSION)
	curl $(SOLR_URL)/$(SOLR36_VERSION)/apache-solr-$(SOLR36_VERSION).tgz > build/$(SOLR36_VERSION)/solr.tgz

build/$(SOLR36_VERSION)/solr: build/$(SOLR36_VERSION)/solr.tgz
	mkdir -p build/$(SOLR36_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR36_VERSION)/solr \
	   	-xzf build/$(SOLR36_VERSION)/solr.tgz apache-solr-$(SOLR36_VERSION)/example
	# only extract contrib (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR36_VERSION)/solr \
		-xzf build/$(SOLR36_VERSION)/solr.tgz apache-solr-$(SOLR36_VERSION)/contrib

build/$(SOLR49_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR49_VERSION)
	curl $(SOLR_URL)/$(SOLR49_VERSION)/solr-$(SOLR49_VERSION).tgz > build/$(SOLR49_VERSION)/solr.tgz

build/$(SOLR49_VERSION)/solr: build/$(SOLR49_VERSION)/solr.tgz
	mkdir -p build/$(SOLR49_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR49_VERSION)/solr \
      -xzf build/$(SOLR49_VERSION)/solr.tgz solr-$(SOLR49_VERSION)/example
	# only extract contrib (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR49_VERSION)/solr \
    -xzf build/$(SOLR49_VERSION)/solr.tgz solr-$(SOLR49_VERSION)/contrib

solr3: build/$(SOLR36_VERSION)/solr build/jetty-$(JETTY8_VERSION)/jetty
	docker build -t bearstech/solr:3 -f Dockerfile.36 .
	docker tag bearstech/solr:3 bearstech/solr:3.6

solr4: build/$(SOLR49_VERSION)/solr
	docker build -t bearstech/solr:4 -f Dockerfile.49 .
	docker tag bearstech/solr:4 bearstech/solr:4.9
	docker tag bearstech/solr:4 bearstech/solr:latest

pull:
	docker pull bearstech/debian:stretch

push:
	docker push bearstech/solr:3
	docker push bearstech/solr:3.6
	docker push bearstech/solr:4
	docker push bearstech/solr:4.9
	docker push bearstech/solr:latest

remove_image:
	docker rmi bearstech/solr:3
	docker rmi bearstech/solr:3.6
	docker rmi bearstech/solr:4
	docker rmi bearstech/solr:4.9
	docker rmi bearstech/solr:latest

bin/goss:
	mkdir -p bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

test: bin/goss
	@docker-compose -f tests_solr/docker-compose.yml down || true
	@docker-compose -f tests_solr/docker-compose.yml up -d
	@docker-compose -f tests_solr/docker-compose.yml exec -T goss \
		goss -g solr.yaml validate --retry-timeout 30s --sleep 1s --max-concurrent 4 --format documentation
	@docker-compose -f tests_solr/docker-compose.yml down || true

tests: test
