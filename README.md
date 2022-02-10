Solr images by Bearstech
========================

Available image:

[bearstech/solr](https://hub.docker.com/r/bearstech/solr/)

Many solr versions are availables from 3.x to 8.x+. Check available [tags](https://hub.docker.com/r/bearstech/solr/tags)

Dockerfiles
-----------

Dockerfiles are available at https://github.com/factorysh/docker-solr

Usage
-----------

Images contain only one Solr core with the default sample configuration provided with Solr release.

- Configuration files are stored in /etc/solr/conf
- Indexes and data are stored in /var/lib/solr/data
- Use a docker volume on /var/lib/solr/data to ensure your data is persistent!

When replacing Solr configuration files, make sure that your /etc/solr/conf/solrconfig.xml contains:
```
<dataDir>${solr.data.dir:}</dataDir>
```


Solr embedded Jetty server listens on TCP port 8983.

Solr URI is :
- /solr/ for Solr 3.x and 4.x, eg.: http://solr:8983/solr/admin/ping
- /solr/core1/ for Solr 5.x and above, eg.: http://solr:8983/solr/core1/admin/ping

You can ajust SOLR_JAVA_MEM to suits your needs (Solr >= 7)

Solr versions < 7 are no longer maintained.

Example
-----------

Dockerfile sample for "factory":
```
# use bearstech solr
FROM bearstech/solr:8

# add user solr
ARG uid=1001
RUN useradd solr -d /opt/solr --uid ${uid} --shell /bin/bash

# Remove default configuration files
RUN rm -rf /etc/solr/conf/*
# Copy my configuration files
COPY /conf/solr /etc/solr/conf

# Adjust owner
RUN chown ${uid}.${uid} /opt/solr
RUN chown ${uid}.${uid} /var/lib/solr
RUN chown ${uid}.${uid} /etc/solr

USER solr

# Default timezone used by solr
#ENV SOLR_TIMEZONE="Europe/Paris"
#ENV SOLR_JAVA_MEM="-Xms512m -Xmx512m"
```

docker-compose.yml sample for "factory":
```
    solr:
        image: $CI_REGISTRY_IMAGE/solr:8
        volumes:
            - ./data/solr8:/var/lib/solr/data
        expose:
            - 8983

    php:
        image: $CI_REGISTRY_IMAGE/php:latest
        environment:
            CI_ENVIRONMENT_NAME: ${CI_ENVIRONMENT_NAME}
            X_SOLR_HOST: ${X_SOLR_HOST:-solr}
            X_SOLR_PORT: ${X_SOLR_PORT:-8983}
            X_SORL_URL:  ${X_SOLR_URL:-/solr}
            # url is solr/core1
            #X_SORL_URL:  ${X_SOLR_URL:-/solr/core1}
            MYSQL_DATABASE: ${MYSQL_DATABASE}
            MYSQL_HOST: ${MYSQL_HOST:-mysql}
            MYSQL_USER: ${MYSQL_USER}
            MYSQL_PASSWORD: ${MYSQL_PASSWORD}
            MAILS_TOKEN: ${MAILS_TOKEN}
            MAILS_USER: ${MAILS_USER}
            MAILS_DOMAIN: ${MAILS_DOMAIN}
            MAILS_PORT: ${MAILS_PORT}

        links:
            -solr
            -mysql
```
