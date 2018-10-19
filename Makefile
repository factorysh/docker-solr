
GOSS_VERSION := 0.3.5

SOLR_URL=http://archive.apache.org/dist/lucene/solr

SOLR35_VERSION=3.5.0
SOLR49_VERSION=4.9.1
SOLR64_VERSION=6.4.2

JETTY8_VERSION=8.1.10

all: pull build

build: solr3 solr4 solr6

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

build/$(SOLR35_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR35_VERSION)
	curl $(SOLR_URL)/$(SOLR35_VERSION)/apache-solr-$(SOLR35_VERSION).tgz > build/$(SOLR35_VERSION)/solr.tgz
build/$(SOLR35_VERSION)/solr: build/$(SOLR35_VERSION)/solr.tgz
	mkdir -p build/$(SOLR35_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR35_VERSION)/solr \
      -xzf build/$(SOLR35_VERSION)/solr.tgz apache-solr-$(SOLR35_VERSION)/example
	# only extract contrib (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR35_VERSION)/solr \
    -xzf build/$(SOLR35_VERSION)/solr.tgz apache-solr-$(SOLR35_VERSION)/contrib
	sed -e 's/solr\.velocity\.enabled:true/solr.velocity.enabled:false/' -i build/$(SOLR35_VERSION)/solr/solr/conf/solrconfig.xml
	#change rights
	find build/$(SOLR35_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR35_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

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
	#change rights
	find build/$(SOLR49_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR49_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR64_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR64_VERSION)
	curl $(SOLR_URL)/$(SOLR64_VERSION)/solr-$(SOLR64_VERSION).tgz > build/$(SOLR64_VERSION)/solr.tgz
build/$(SOLR64_VERSION)/solr: build/$(SOLR64_VERSION)/solr.tgz
	mkdir -p build/$(SOLR64_VERSION)/solr
	#extract contrib
	tar --strip-components=1 -C build/$(SOLR64_VERSION)/solr \
      -xzf build/$(SOLR64_VERSION)/solr.tgz solr-$(SOLR64_VERSION)/contrib
	# extract dist
	tar --strip-components=1 -C build/$(SOLR64_VERSION)/solr \
      -xzf build/$(SOLR64_VERSION)/solr.tgz solr-$(SOLR64_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR64_VERSION)/solr \
      -xzf build/$(SOLR64_VERSION)/solr.tgz solr-$(SOLR64_VERSION)/server
	# remove old logs
	rm -rf build/$(SOLR64_VERSION)/solr/server/logs
	#change rights
	find build/$(SOLR64_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR64_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

solr3: build/$(SOLR35_VERSION)/solr build/jetty-$(JETTY8_VERSION)/jetty
	docker build -t bearstech/solr:3 -f Dockerfile.35 .
	docker tag bearstech/solr:3 bearstech/solr:3.5

solr4: build/$(SOLR49_VERSION)/solr
	docker build -t bearstech/solr:4 -f Dockerfile.49 .
	docker tag bearstech/solr:4 bearstech/solr:4.9

solr6: build/$(SOLR64_VERSION)/solr
	docker build -t bearstech/solr:4 -f Dockerfile.64 .
	docker tag bearstech/solr:4 bearstech/solr:6.4
	docker tag bearstech/solr:4 bearstech/solr:latest

pull:
	docker pull bearstech/debian:stretch

push:
	docker push bearstech/solr:3
	docker push bearstech/solr:3.5
	docker push bearstech/solr:4
	docker push bearstech/solr:4.9
	docker push bearstech/solr:latest

remove_image:
	docker rmi bearstech/solr:3
	docker rmi bearstech/solr:3.5
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
