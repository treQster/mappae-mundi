#!/bin/bash

set -x -e

cd /map/

DATA=./data/
mkdir -p $DATA

carto ./project.mml > ./mapnik.xml

cd $DATA

./get-shapefiles.sh

wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ln -s monaco-latest.osm.pbf data.osm.pbf

osm2pgsql -s -C 300 -c -G --hstore --style /map/openstreetmap-carto.style -H osmpg -U osm -d osm /map/data/data.osm.pbf
