#!/bin/sh

set -e
export PGUSER="$POSTGRES_USER"

"${psql[@]}" -c "CREATE EXTENSION hstore;"
