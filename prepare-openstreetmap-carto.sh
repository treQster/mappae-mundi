#!/bin/bash

HERE=$PWD

DATA=$PWD/data/openstreetmap-carto

mkdir -p $DATA
mkdir -p $DATA/data

./maps/openstreetmap-carto/scripts/get-shapefiles.py -d $DATA/data/

cp -r ./maps/openstreetmap-carto/* $DATA/

carto $DATA/project.mml > $DATA/mapnik.xml

cd $DATA
wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ln -s monaco-latest.osm.pbf data.osm.pbf
