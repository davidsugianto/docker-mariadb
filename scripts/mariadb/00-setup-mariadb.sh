#!/bin/sh

create_database() {
  local database=$1
  echo "Creating database '$database'"
  mysql --user=root --password=${MARIADB_ROOT_PASSWORD} <<-EOSQL
    CREATE DATABASE $database;
EOSQL
}

if [ -e "/home/mariadb/staging/${MARIADB_STAGING_DATABASE}-$(date +\%A).sql" -a -e "/home/mariadb/production/${MARIADB_PRODUCTION_DATABASE}-$(date +\%A).sql" ]; then
  echo "Database is ready to import"
  if [ -n "$MARIADB_MULTIPLE_DATABASE" ]; then
    echo "Multiple database creation requested: $MARIADB_MULTIPLE_DATABASE"
    for db in $(echo $MARIADB_MULTIPLE_DATABASE | tr ',' ' '); do
      create_database $db
    done
    echo "Add Permission Database ${MARIADB_STAGING_DATABASE} to ${MARIADB_USER} "
    mysql --user=root --password=${MARIADB_ROOT_PASSWORD} --execute="GRANT ALL ON ${MARIADB_STAGING_DATABASE}.* TO '${MARIADB_USER}';"
    echo "Add Permission Database ${MARIADB_PRODUCTION_DATABASE} to ${MARIADB_USER} "
    mysql --user=root --password=${MARIADB_ROOT_PASSWORD} --execute="GRANT ALL ON ${MARIADB_PRODUCTION_DATABASE}.* TO '${MARIADB_USER}';"
    echo "Importing Database Staging"
    cd /home/mariadb/staging
    mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} ${MARIADB_STAGING_DATABASE} < ${MARIADB_STAGING_DATABASE}-$(date +\%A).sql
    echo "Importing Database Production"
    cd /home/mariadb/production
    mysql --user=${MARIADB_USER} --password=${MARIADB_PASSWORD} ${MARIADB_PRODUCTION_DATABASE} < ${MARIADB_PRODUCTION_DATABASE}-$(date +\%A).sql
    echo "Importing success and database is ready"
  fi
else 
  echo "Database is not ready to import"
  if [ -n "$MARIADB_MULTIPLE_DATABASE" ]; then
    echo "Multiple database creation requested: $MARIADB_MULTIPLE_DATABASE"
    for db in $(echo $MARIADB_MULTIPLE_DATABASE | tr ',' ' '); do
      create_database $db
    done
    echo "Add Permission Database ${MARIADB_STAGING_DATABASE} to ${MARIADB_USER} "
    mysql --user=root --password=${MARIADB_ROOT_PASSWORD} --execute="GRANT ALL ON ${MARIADB_STAGING_DATABASE}.* TO '${MARIADB_USER}';"
    echo "Add Permission Database ${MARIADB_PRODUCTION_DATABASE} to ${MARIADB_USER} "
    mysql --user=root --password=${MARIADB_ROOT_PASSWORD} --execute="GRANT ALL ON ${MARIADB_PRODUCTION_DATABASE}.* TO '${MARIADB_USER}';"
    echo "Database is ready"
  fi
fi

# Call command issued to the docker service
exec "$@"
