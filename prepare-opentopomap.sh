#!/bin/bash

set -x -e

cd /map/

DATA=$PWD/data/

mkdir -p $DATA/data

cd $DATA/
wget http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip
wget http://data.openstreetmapdata.com/water-polygons-split-3857.zip
unzip water-polygons-generalized-3857.zip
unzip water-polygons-split-3857.zip

wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ln -s monaco-latest.osm.pbf data.osm.pbf || echo "Symlink already exists?"


