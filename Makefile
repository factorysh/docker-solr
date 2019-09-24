.PHONY: build
GOSS_VERSION := 0.3.5
GIT_VERSION := $(shell git rev-parse HEAD)
GIT_DATE := $(shell git show -s --format=%ci HEAD)

SOLR_URL=http://archive.apache.org/dist/lucene/solr

SOLR35_VERSION=3.5.0
SOLR49_VERSION=4.9.1
SOLR55_VERSION=5.5.5
SOLR64_VERSION=6.4.2
SOLR66_VERSION=6.6.5
SOLR75_VERSION=7.5.0

JETTY8_VERSION=8.1.10

all: pull build

build: solr3 solr4 solr5 solr6 solr7

build/$(SOLR35_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR35_VERSION)
	curl $(SOLR_URL)/$(SOLR35_VERSION)/apache-solr-$(SOLR35_VERSION).tgz > build/$(SOLR35_VERSION)/solr.tgz
build/$(SOLR35_VERSION)/solr: build/$(SOLR35_VERSION)/solr.tgz
	mkdir -p build/$(SOLR35_VERSION)/solr
	#only extract example (contains solr + jetty)
	tar --strip-components=2 -C build/$(SOLR35_VERSION)/solr \
      -xzf build/$(SOLR35_VERSION)/solr.tgz apache-solr-$(SOLR35_VERSION)/example
	# only extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR35_VERSION)/solr \
    -xzf build/$(SOLR35_VERSION)/solr.tgz apache-solr-$(SOLR35_VERSION)/contrib apache-solr-$(SOLR35_VERSION)/dist
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
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR49_VERSION)/solr \
    -xzf build/$(SOLR49_VERSION)/solr.tgz solr-$(SOLR49_VERSION)/contrib solr-$(SOLR49_VERSION)/dist
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
	#change rights
	find build/$(SOLR66_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR66_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

build/$(SOLR75_VERSION)/solr.tgz:
	# fetch archive
	mkdir -p build/$(SOLR75_VERSION)
	curl $(SOLR_URL)/$(SOLR75_VERSION)/solr-$(SOLR75_VERSION).tgz > build/$(SOLR75_VERSION)/solr.tgz
build/$(SOLR75_VERSION)/solr: build/$(SOLR75_VERSION)/solr.tgz
	mkdir -p build/$(SOLR75_VERSION)/solr
	# extract contrib + dist (contains additionals solr libs)
	tar --strip-components=1 -C build/$(SOLR75_VERSION)/solr \
      -xzf build/$(SOLR75_VERSION)/solr.tgz solr-$(SOLR75_VERSION)/contrib solr-$(SOLR75_VERSION)/dist
	# extract server
	tar --strip-components=1 -C build/$(SOLR75_VERSION)/solr \
      -xzf build/$(SOLR75_VERSION)/solr.tgz solr-$(SOLR75_VERSION)/server
	# remove old logs
	rm -rf build/$(SOLR75_VERSION)/solr/server/logs
	#change rights
	find build/$(SOLR75_VERSION)/solr -type d -print0 | xargs -0 chmod 0777
	find build/$(SOLR75_VERSION)/solr -type f -print0 | xargs -0 chmod 0666

solr3: build/$(SOLR35_VERSION)/solr
	docker build \
		-t bearstech/solr:3 \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.35 \
		.
	docker tag bearstech/solr:3 bearstech/solr:3.5

solr4: build/$(SOLR49_VERSION)/solr
	docker build \
		-t bearstech/solr:4 \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.49 \
		.
	docker tag bearstech/solr:4 bearstech/solr:4.9

solr5: build/$(SOLR55_VERSION)/solr
	docker build \
		-t bearstech/solr:5 \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.55 \
		.
	docker tag bearstech/solr:5 bearstech/solr:5.5

solr6: build/$(SOLR64_VERSION)/solr build/$(SOLR66_VERSION)/solr
	docker build \
		-t bearstech/solr:6.4 \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.64 \
		.
	docker build \
		-t bearstech/solr:6\
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.66 \
		.
	docker tag bearstech/solr:6 bearstech/solr:6.6

solr7: build/$(SOLR75_VERSION)/solr
	docker build \
		-t bearstech/solr:7 \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		--build-arg GIT_DATE="${GIT_DATE}" \
		-f Dockerfile.75 \
		.
	docker tag bearstech/solr:7 bearstech/solr:7.5
	docker tag bearstech/solr:7 bearstech/solr:latest

pull:
	docker pull bearstech/debian:stretch

push:
	docker push bearstech/solr:3
	docker push bearstech/solr:3.5
	docker push bearstech/solr:4
	docker push bearstech/solr:4.9
	docker push bearstech/solr:6
	docker push bearstech/solr:6.6
	docker push bearstech/solr:6.4
	docker push bearstech/solr:7
	docker push bearstech/solr:7.5
	docker push bearstech/solr:latest

remove_image:
	docker rmi bearstech/solr:3
	docker rmi bearstech/solr:3.5
	docker rmi bearstech/solr:4
	docker rmi bearstech/solr:4.9
	docker rmi bearstech/solr:6
	docker rmi bearstech/solr:6.6
	docker rmi bearstech/solr:6.4
	docker rmi bearstech/solr:7
	docker rmi bearstech/solr:7.5
	docker rmi bearstech/solr:latest

bin/goss:
	mkdir -p bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

test3.5: bin/goss
	make -C tests_solr tests SOLR_VERSION=3.5 BASE_URL=/solr/

test4.9: bin/goss
	make -C tests_solr tests SOLR_VERSION=4.9 BASE_URL=/solr/

test5.5: bin/goss
	make -C tests_solr tests SOLR_VERSION=5.5 BASE_URL=/solr/

test6.4: bin/goss
	make -C tests_solr tests SOLR_VERSION=6.4 BASE_URL=/solr/core1/

test6.6: bin/goss
	make -C tests_solr tests SOLR_VERSION=6.6 BASE_URL=/solr/core1/

test7.5: bin/goss
	make -C tests_solr tests SOLR_VERSION=7.5 BASE_URL=/solr/core1/

down:
	make -C tests_solr down

tests: | test3.5 test4.9 test6.4 test6.6 test7.5

clean:
	rm -rf build
