FROM idiots718/mysql-client:ubuntu-18.04

LABEL maintainer David Sugianto <idiots718@gmail.com>

ENV MARIADB_USER=${MARIADB_USER} \
    MARIADB_PASSWORD=${MARIADB_PASSWORD} \
    MARIADB_HOST=${MARIADB_HOST} \
    MARIADB_STAGING_DATABASE=${MARIADB_STAGING_DATABASE} \
    MARIADB_PRODUCTION_DATABASE=${MARIADB_PRODUCTION_DATABASE}

RUN mkdir -p /backups/staging && chmod -R 777 /backups/staging
RUN mkdir -p /backups/production && chmod -R 777 /backups/production
RUN chmod -R 777 /backups

COPY ./scripts /scripts
RUN find /scripts -type f -iname "*.sh" -exec chmod a+x {} \;
VOLUME /backups

ENTRYPOINT ["/scripts/entrypoint.sh"]

