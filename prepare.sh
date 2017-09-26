#!/bin/bash

DATA=$PWD/data/

mkdir -p $DATA

./openstreetmap-carto/scripts/get-shapefiles.py -d $DATA

cp -r ./openstreetmap-carto/symbols $DATA/
cp ./openstreetmap-carto/openstreetmap-carto.{lua,style} $DATA/

carto ./openstreetmap-carto/project.mml > $DATA/mapnik.xml
