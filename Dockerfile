FROM bearstech/debian:stretch
ENV SOLR_VERSION=3.6.2
ENV SOLR=apache-solr-$SOLR_VERSION

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN \
# fetch archive
    curl http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz > /tmp/$SOLR.tgz \
    && mkdir /tmp/solr \
    && mkdir -p /opt/solr/solr/conf \
# only extract example (contains solr + jetty)
    && tar --strip-components=2 -C /tmp/solr -xzf /tmp/$SOLR.tgz $SOLR/example \
# only extract contrib (contains additionals solr libs)
    && tar --strip-components=1 -C /tmp/solr -xzf /tmp/$SOLR.tgz $SOLR/contrib \
# only take what we need from example directory
    && cp -R /tmp/solr/etc /tmp/solr/lib /tmp/solr/webapps /tmp/solr/contrib /tmp/solr/start.jar /opt/solr \
    && cp /tmp/solr/solr/solr.xml /opt/solr/solr/



# use bearstech stretch
FROM bearstech/debian:stretch

ENV DEBIAN_FRONTEND noninteractive

ENV SOLR_PORT=8983

# we need openjdk
RUN apt-get update && apt-get install -y \
        openjdk-8-jre-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN \
# config dir
        mkdir -p /opt/solr/solr/conf \
# data dir
        && mkdir /var/lib/solr

WORKDIR /opt/solr
COPY --from=0 /opt/solr .

# Run Apache Solr
EXPOSE $SOLR_PORT
CMD ["java", "-Djetty.port=8983", "-jar", "start.jar"]
