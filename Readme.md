Solr images for docker
=======================

Les images sont fournies avec un seul core avec une configuration d'exemple fournie par défaut.

- La configuration est dans /etc/solr/conf .
- Les indexes et data sont stockés /var/lib/solr/data .
- Utilisez un volume sur /var/lib/solr si vous souhaitez des données persistantes !

Quand vous remplacerer les fichiers de configuration de Solr, assurez vous que votre fichier /etc/solr/conf/solrconfig.xml contienne :
```
<dataDir>${solr.data.dir:}</dataDir>
```


Solr-Jetty http écoute sur le port 8983/tcp

L'url de sorl est :
- /solr/ pour sorl 3.x et 4.x, exemple : http://solr:8983/solr//admin/ping
- /solr/core1/ pour Sorl 6 et solr 7, exemple : http://solr:8983/solr/core1/admin/ping


Utilisation
-----------

Exemple de Dockerfile :
```
# use bearstech solr (stretch)
FROM bearstech/solr:3.5

# Remove default configuration files
RUN rm -rf /etc/solr/conf/*
# Copy my configuration files
COPY /conf/solr /etc/solr/conf

# Default timezone used by solr
#ENV SOLR_TIMEZONE="Europe/Paris"
```

Exemple de docker-compose.yml "factory":
```
    solr:
        image: $CI_REGISTRY_IMAGE/solr:latest
        volumes:
            - ./data/scraping_solr_data:/var/lib/solr
        expose:
            - 8983

    php:
        image: $CI_REGISTRY_IMAGE/php:latest
        environment:
            CI_ENVIRONMENT_NAME: ${CI_ENVIRONMENT_NAME}
            X_SOLR_HOST: ${X_SOLR_HOST:-solr}
            X_SOLR_PORT: ${X_SOLR_PORT:-8983}
            X_SORL_URL:  ${X_SOLR_URL:-/solr/}
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
