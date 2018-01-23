#!/bin/sh

set -e -x

export PGUSER="$POSTGRES_USER"

"${psql[@]}" -c "CREATE EXTENSION hstore;"

#for DB in $POSTGRES_DBS; do
#  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE DATABASE $DB template template_postgis;" 
#  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname $DB -c "CREATE EXTENSION hstore;" 
#done


