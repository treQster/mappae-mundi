FROM alpine:3.6
MAINTAINER Sergei Beilin <sergei.beilin@treqster.net>

ENV LANG en_US.utf8
ENV DATA /data
ENV OSM2PGSQL_VERSION 0.94.0-RC1

VOLUME /data


RUN apk -X http://nl.alpinelinux.org/alpine/edge/testing/ -U add \
        ca-certificates openssl postgresql-client \
        curl libpq expat proj4 bzip2 zlib boost boost-system boost-filesystem boost-iostreams lua

RUN apk -X http://nl.alpinelinux.org/alpine/edge/testing/ -U add --virtual .build-dependencies \
        make cmake g++ python expat-dev proj4-dev bzip2-dev zlib-dev boost-dev postgresql-dev lua-dev
#
#ENV CXX g++ -ansi
#
#
#RUN wget -O geos-3.5.1.tar.gz https://github.com/OSGeo/geos/archive/3.5.1.tar.gz && \
#    tar zxf geos-3.5.1.tar.gz && \
#    mkdir geos-3.5.1/build && \
#    cd geos-3.5.1/build && \
#    cmake .. && \
#    make && \
#    make check && \
#    make install && \
#    ldconfig


RUN wget -O osm2pgsql-$OSM2PGSQL_VERSION.tar.gz https://github.com/openstreetmap/osm2pgsql/archive/$OSM2PGSQL_VERSION.tar.gz && \
    tar xzf osm2pgsql-$OSM2PGSQL_VERSION.tar.gz && \
    mkdir build && cd build && \
    cmake ../osm2pgsql-$OSM2PGSQL_VERSION && make && make install && \
    apk del .build-dependencies && \
    mkdir -p $DATA && \
    rm -rf /osm2pgsql-$OSM2PGSQL_VERSION /osm2pgsql-$OSM2PGSQL_VERSION.tar.gz /build /var/cache/apk/*
