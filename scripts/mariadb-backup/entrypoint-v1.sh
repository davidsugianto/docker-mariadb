#!/bin/sh

crontab -l > backupcron

echo "0 0 * * * mysqldump -u $MARIADB_USER -p$MARIADB_PASSWORD -h $MARIADB_HOST $MARIADB_STAGING_DATABASE > /backups/staging/$MARIADB_STAGING_DATABASE-$(date +\%A).sql" >> backupcron
echo "0 0 * * * mysqldump -u $MARIADB_USER -p$MARIADB_PASSWORD -h $MARIADB_HOST $MARIADB_PRODUCTION_DATABASE > /backups/production/$MARIADB_PRODUCTION_DATABASE-$(date +\%A).sql" >> backupcron

export today="$(date +\%A)"
sed -i 's/'"$today"'/$(date +\%A)/' backupcron

crontab backupcron
echo "Cron job Database Backup is Completed"

service cron start

info "** Starting CronJob **"

# Call command issued to the docker service
exec "$@"
