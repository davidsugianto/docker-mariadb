#!/bin/sh

mysqldump -u $MARIADB_USER -p$MARIADB_PASSWORD -h $MARIADB_HOST $MARIADB_PRODUCTION_DATABASE > /backups/production/$MARIADB_PRODUCTION_DATABASE-$(date +\%A).sql
echo "$MARIADB_PRODUCTION_DATABASE-$(date +%A%d%m%Y)"

# Call command issued to the docker service
exec "$@"
