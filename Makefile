
include Makefile.lint
include Makefile.build_args

.PHONY: build
GOSS_VERSION := 0.3.5

SOLR_URL=http://archive.apache.org/dist/lucene/solr

SOLR36_VERSION=3.6.2
SOLR49_VERSION=4.9.1
SOLR55_VERSION=5.5.5
SOLR64_VERSION=6.4.2
SOLR66_VERSION=6.6.6
SOLR77_VERSION=7.7.3
SOLR8_VERSION=8.11.1

LOG4J_VERSION=2.17.2

JETTY8_VERSION=8.1.10

all: pull build

push-%:
	$(eval version=$(shell echo $@ | cut -d- -f2))
	docker push bearstech/solr:$(version)

push: push-8

build: clean solr-8

build/$(SOLR36_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR36_VERSION)
	curl $(SOLR_URL)/$(SOLR36_VERSION)/apache-solr-$(SOLR36_VERSION).tgz > build/$(SOLR36_VERSION)/solr.tgz
build/$(SOLR36_VERSION)/solr: build/$(SOLR36_VERSION)/solr.tgz
	mkdir -p build/$(SOLR36_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR36_VERSION)/solr \
      -xzf build/$(SOLR36_VERSION)/solr.tgz apache-solr-$(SOLR36_VERSION)/example
	# only extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR36_VERSION)/solr \
    -xzf build/$(SOLR36_VERSION)/solr.tgz apache-solr-$(SOLR36_VERSION)/contrib apache-solr-$(SOLR36_VERSION)/dist
	sed -e 's/solr\.velocity\.enabled:true/solr.velocity.enabled:false/' -i build/$(SOLR36_VERSION)/solr/solr/conf/solrconfig.xml
	#change rights
	find build/$(SOLR36_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR36_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR49_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR49_VERSION)
	curl $(SOLR_URL)/$(SOLR49_VERSION)/solr-$(SOLR49_VERSION).tgz > build/$(SOLR49_VERSION)/solr.tgz
build/$(SOLR49_VERSION)/solr: build/$(SOLR49_VERSION)/solr.tgz
	mkdir -p build/$(SOLR49_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR49_VERSION)/solr \
      -xzf build/$(SOLR49_VERSION)/solr.tgz solr-$(SOLR49_VERSION)/example
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR49_VERSION)/solr \
    -xzf build/$(SOLR49_VERSION)/solr.tgz solr-$(SOLR49_VERSION)/contrib solr-$(SOLR49_VERSION)/dist
	# remove ChainSaw from log4j-1.2.x
	zip -q -d build/$(SOLR49_VERSION)/solr/lib/ext/log4j-*.jar org/apache/log4j/chainsaw/*
	#change rights
	find build/$(SOLR49_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR49_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR55_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR55_VERSION)
	curl $(SOLR_URL)/$(SOLR55_VERSION)/solr-$(SOLR55_VERSION).tgz > build/$(SOLR55_VERSION)/solr.tgz
build/$(SOLR55_VERSION)/solr: build/$(SOLR55_VERSION)/solr.tgz
	mkdir -p build/$(SOLR55_VERSION)/solr
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR55_VERSION)/solr \
      -xzf build/$(SOLR55_VERSION)/solr.tgz solr-$(SOLR55_VERSION)/contrib solr-$(SOLR55_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR55_VERSION)/solr \
      -xzf build/$(SOLR55_VERSION)/solr.tgz solr-$(SOLR55_VERSION)/server
	# remove old logs
	rm -rf build/$(SOLR55_VERSION)/solr/server/logs
	# remove ChainSaw from log4j-1.2.x
	zip -q -d build/$(SOLR55_VERSION)/solr/server/lib/ext/log4j-*.jar org/apache/log4j/chainsaw/*
	#change rights
	find build/$(SOLR55_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR55_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR64_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR64_VERSION)
	curl $(SOLR_URL)/$(SOLR64_VERSION)/solr-$(SOLR64_VERSION).tgz > build/$(SOLR64_VERSION)/solr.tgz
build/$(SOLR64_VERSION)/solr: build/$(SOLR64_VERSION)/solr.tgz
	mkdir -p build/$(SOLR64_VERSION)/solr
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR64_VERSION)/solr \
      -xzf build/$(SOLR64_VERSION)/solr.tgz solr-$(SOLR64_VERSION)/contrib solr-$(SOLR64_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR64_VERSION)/solr \
      -xzf build/$(SOLR64_VERSION)/solr.tgz solr-$(SOLR64_VERSION)/server
	# remove old logs
	rm -rf build/$(SOLR64_VERSION)/solr/server/logs
	# remove ChainSaw from log4j-1.2.x
	zip -q -d build/$(SOLR64_VERSION)/solr/server/lib/ext/log4j-*.jar org/apache/log4j/chainsaw/*
	#change rights
	find build/$(SOLR64_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR64_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR66_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR66_VERSION)
	curl $(SOLR_URL)/$(SOLR66_VERSION)/solr-$(SOLR66_VERSION).tgz > build/$(SOLR66_VERSION)/solr.tgz
build/$(SOLR66_VERSION)/solr: build/$(SOLR66_VERSION)/solr.tgz
	mkdir -p build/$(SOLR66_VERSION)/solr
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR66_VERSION)/solr \
      -xzf build/$(SOLR66_VERSION)/solr.tgz solr-$(SOLR66_VERSION)/contrib solr-$(SOLR66_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR66_VERSION)/solr \
      -xzf build/$(SOLR66_VERSION)/solr.tgz solr-$(SOLR66_VERSION)/server
	# remove old logs
	rm -rf build/$(SOLR66_VERSION)/solr/server/logs
	# remove ChainSaw from log4j-1.2.x
	zip -q -d build/$(SOLR66_VERSION)/solr/server/lib/ext/log4j-*.jar org/apache/log4j/chainsaw/*
	#change rights
	find build/$(SOLR66_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR66_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR77_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR77_VERSION)
	curl $(SOLR_URL)/$(SOLR77_VERSION)/solr-$(SOLR77_VERSION).tgz > build/$(SOLR77_VERSION)/solr.tgz
build/$(SOLR77_VERSION)/solr: build/$(SOLR77_VERSION)/solr.tgz
	# extract contrib + dist (contains additionals solr libs)
	mkdir -p build/$(SOLR77_VERSION)/solr
	tar --strip-components=1 -C build/$(SOLR77_VERSION)/solr \
      -xzf build/$(SOLR77_VERSION)/solr.tgz solr-$(SOLR77_VERSION)/contrib solr-$(SOLR77_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR77_VERSION)/solr \
      -xzf build/$(SOLR77_VERSION)/solr.tgz solr-$(SOLR77_VERSION)/server
	# fetch log4j
	mkdir -p build/log4j$(LOG4J_VERSION)
	curl https://downloads.apache.org/logging/log4j/$(LOG4J_VERSION)/apache-log4j-$(LOG4J_VERSION)-bin.tar.gz > build/log4j$(LOG4J_VERSION)/log4j.tgz
	# extract log4j
	mkdir -p build/log4j$(LOG4J_VERSION)/log4j
	tar --strip-components=1 -C build/log4j$(LOG4J_VERSION)/log4j \
    -xzf build/log4j$(LOG4J_VERSION)/log4j.tgz
	# replace log4j
	rm -f build/$(SOLR77_VERSION)/solr/server/lib/ext/log4j*.jar
	rm -f build/$(SOLR77_VERSION)/solr/contrib/prometheus-exporter/lib/log4j*.jar
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-slf4j-impl-$(LOG4J_VERSION).jar build/$(SOLR77_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-core-$(LOG4J_VERSION).jar       build/$(SOLR77_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-1.2-api-$(LOG4J_VERSION).jar    build/$(SOLR77_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-api-$(LOG4J_VERSION).jar        build/$(SOLR77_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-slf4j-impl-$(LOG4J_VERSION).jar build/$(SOLR77_VERSION)/solr/contrib/prometheus-exporter/lib/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-core-$(LOG4J_VERSION).jar       build/$(SOLR77_VERSION)/solr/contrib/prometheus-exporter/lib/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-api-$(LOG4J_VERSION).jar        build/$(SOLR77_VERSION)/solr/contrib/prometheus-exporter/lib/

	# remove old logs
	rm -rf build/$(SOLR77_VERSION)/solr/server/logs
	#change rights
	find build/$(SOLR77_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR77_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR8_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR8_VERSION)
	curl $(SOLR_URL)/$(SOLR8_VERSION)/solr-$(SOLR8_VERSION).tgz > build/$(SOLR8_VERSION)/solr.tgz
build/$(SOLR8_VERSION)/solr: build/$(SOLR8_VERSION)/solr.tgz
	# extract contrib + dist (contains additionals solr libs)
	mkdir -p build/$(SOLR8_VERSION)/solr
	tar --strip-components=1 -C build/$(SOLR8_VERSION)/solr \
      -xzf build/$(SOLR8_VERSION)/solr.tgz solr-$(SOLR8_VERSION)/contrib solr-$(SOLR8_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR8_VERSION)/solr \
      -xzf build/$(SOLR8_VERSION)/solr.tgz solr-$(SOLR8_VERSION)/server
	# fetch log4j
	mkdir -p build/log4j$(LOG4J_VERSION)
	curl https://downloads.apache.org/logging/log4j/$(LOG4J_VERSION)/apache-log4j-$(LOG4J_VERSION)-bin.tar.gz > build/log4j$(LOG4J_VERSION)/log4j.tgz
	# extract log4j
	mkdir -p build/log4j$(LOG4J_VERSION)/log4j
	tar --strip-components=1 -C build/log4j$(LOG4J_VERSION)/log4j \
    -xzf build/log4j$(LOG4J_VERSION)/log4j.tgz
	# replace log4j
	rm -f build/$(SOLR8_VERSION)/solr/server/lib/ext/log4j*.jar
	rm -f build/$(SOLR8_VERSION)/solr/contrib/prometheus-exporter/lib/log4j*.jar
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-slf4j-impl-$(LOG4J_VERSION).jar build/$(SOLR8_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-core-$(LOG4J_VERSION).jar       build/$(SOLR8_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-1.2-api-$(LOG4J_VERSION).jar    build/$(SOLR8_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-api-$(LOG4J_VERSION).jar        build/$(SOLR8_VERSION)/solr/server/lib/ext/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-slf4j-impl-$(LOG4J_VERSION).jar build/$(SOLR8_VERSION)/solr/contrib/prometheus-exporter/lib/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-core-$(LOG4J_VERSION).jar       build/$(SOLR8_VERSION)/solr/contrib/prometheus-exporter/lib/
	cp build/log4j$(LOG4J_VERSION)/log4j/log4j-api-$(LOG4J_VERSION).jar        build/$(SOLR8_VERSION)/solr/contrib/prometheus-exporter/lib/

	# remove old logs
	rm -rf build/$(SOLR8_VERSION)/solr/server/logs
	#change rights
	find build/$(SOLR8_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR8_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

solr-3: build/$(SOLR36_VERSION)/solr
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:3 \
		-f Dockerfile.36 \
		.
	docker tag bearstech/solr:3 bearstech/solr:3.6

solr-4: build/$(SOLR49_VERSION)/solr
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:4 \
		-f Dockerfile.49 \
		.
	docker tag bearstech/solr:4 bearstech/solr:4.9

solr-5: build/$(SOLR55_VERSION)/solr
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:5 \
		-f Dockerfile.55 \
		.
	docker tag bearstech/solr:5 bearstech/solr:5.5

solr-6: build/$(SOLR64_VERSION)/solr build/$(SOLR66_VERSION)/solr
	docker build \
    $(DOCKER_BUILD_ARGS) \
    -t bearstech/solr:6.4\
    -f Dockerfile.64 \
    .
	docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:6\
		-f Dockerfile.66 \
		.
	docker tag bearstech/solr:6 bearstech/solr:6.6

solr-7: build/$(SOLR77_VERSION)/solr
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:7 \
		-f Dockerfile.77 \
		.
	docker tag bearstech/solr:7 bearstech/solr:7.7

solr-8: build/$(SOLR8_VERSION)/solr
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/solr:8 \
		-f Dockerfile.8 \
		.
	docker tag bearstech/solr:8 bearstech/solr:8


pull:
	docker pull bearstech/java:11

remove_image:
	docker rmi -f $(shell docker images -q --filter="reference=bearstech/solr") || true

bin/goss:
	mkdir -p bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

test-3.6: bin/goss
	make -C tests_solr tests SOLR_VERSION=3.6 SOLR_FULL_VERSION=${SOLR36_VERSION} BASE_URL=/solr/

test-4.9: bin/goss
	make -C tests_solr tests SOLR_VERSION=4.9 SOLR_FULL_VERSION=${SOLR49_VERSION} BASE_URL=/solr/

test-5.5: bin/goss
	make -C tests_solr tests SOLR_VERSION=5.5 SOLR_FULL_VERSION=${SOLR55_VERSION} BASE_URL=/solr/core1/

test-6.4: bin/goss
	make -C tests_solr tests SOLR_VERSION=6.4 SOLR_FULL_VERSION=${SOLR64_VERSION} BASE_URL=/solr/core1/

test-6.6: bin/goss
	make -C tests_solr tests SOLR_VERSION=6.6 SOLR_FULL_VERSION=${SOLR66_VERSION} BASE_URL=/solr/core1/

test-7.7: bin/goss
	make -C tests_solr tests SOLR_VERSION=7.7 SOLR_FULL_VERSION=${SOLR77_VERSION} BASE_URL=/solr/core1/

test-8: bin/goss
	make -C tests_solr tests SOLR_VERSION=8 SOLR_FULL_VERSION=${SOLR8_VERSION} BASE_URL=/solr/core1/

down:
	make -C tests_solr down

tests: | test-8

clean:
	mkdir -p build/
	find build/ -maxdepth 2 -type d -name solr -exec rm -rf {} \;
