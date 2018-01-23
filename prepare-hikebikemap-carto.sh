#!/bin/bash

set -x -e

cd /map/

DATA=./data/
mkdir -p $DATA

# cartocc ./project.mml ./pg.mml.patch  >> local_project.mml

# carto ./local_project.mml > ./mapnik.xml

./get-shapefiles.sh

cd $DATA

wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ln -s monaco-latest.osm.pbf data.osm.pbf || echo "Symlink already exists!"

osm2pgsql -s -C 300 -c -G --hstore --style /map/openstreetmap-carto.style -H osmpg -U osm -d osm /map/data/data.osm.pbf

