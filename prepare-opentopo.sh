#!/bin/bash

set -x -e

HERE=$PWD

DATA=$PWD/data/opentopomaps

mkdir -p $DATA
mkdir -p $DATA/data

cd $DATA/data/
wget http://data.openstreetmapdata.com/water-polygons-generalized-3857.zip
wget http://data.openstreetmapdata.com/water-polygons-split-3857.zip
unzip water-polygons-generalized-3857.zip
unzip water-polygons-split-3857.zip
cd $HERE

cp -r ./maps/OpenTopoMap/mapnik/* $DATA/

cd $DATA
ln -s ./opentopomap.xml mapnik.xml
wget http://download.geofabrik.de/europe/monaco-latest.osm.pbf
ln -s monaco-latest.osm.pbf data.osm.pbf
