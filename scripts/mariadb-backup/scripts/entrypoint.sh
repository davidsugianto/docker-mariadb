#!/bin/sh

crontab -l > backupcron

echo "0 0 * * * /scripts/backup-staging.sh >> /var/log/cron.log" >> backupcron
echo "5 0 * * * /scripts/backup-production.sh >> /var/log/cron.log" >> backupcron

crontab backupcron
echo "Cron job Database Backup is Completed"

service cron start

echo "** Starting CronJob **"

touch /var/log/cron.log /var/log/cron.log

tail -f /var/log/cron.log

# Call command issued to the docker service
exec "$@"
