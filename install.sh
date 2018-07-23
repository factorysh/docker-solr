#!/bin/bash

set -e

# temp dir
mkdir /tmp/solr

# fetch archive
curl http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz > /tmp/$SOLR.tgz

# only extract example (contains solr + jetty)
tar --strip-components=2 -C /tmp/solr -xzf /tmp/$SOLR.tgz $SOLR/example
# only extract contrib (contains additionals solr libs)
tar --strip-components=1 -C /tmp/solr -xzf /tmp/$SOLR.tgz $SOLR/contrib

# data dir
mkdir /var/lib/solr

# only take what we need from example directory
cp -R /tmp/solr/etc /tmp/solr/lib /tmp/solr/webapps /tmp/solr/contrib /tmp/solr/start.jar \
    /opt/solr
cp /tmp/solr/solr/solr.xml /opt/solr/solr/
cp -R /tmp/solr/solr/conf /opt/solr/solr/conf

# remove tmp files
rm -rf /tmp/solr /tmp/$SOLR.tgz
