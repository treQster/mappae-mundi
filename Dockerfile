FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3  \
    libmapnik3.0 mapnik-utils\
    python3-mapnik python3-pip \
    wget curl unzip \
    gdal-bin osm2pgsql \
    postgresql-client

# Install fonts needed for rendering
RUN apt-get install -y fontconfig \
    fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont ttf-hanazono \
    fonts-khmeros fonts-sil-padauk fonts-sipa-arundina 

RUN wget https://noto-website.storage.googleapis.com/pkgs/NotoEmoji-unhinted.zip && \
    unzip -o NotoEmoji-unhinted.zip && \
    mv *ttf /usr/share/fonts/truetype/noto && \
    rm NotoEmoji-unhinted.zip && \
    fc-cache -f -v

#RUN wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansAdlamUnjoined-hinted.zip && \
#    unzip -o NotoSansAdlamUnjoined-hinted.zip && \
#    mv *ttf /usr/share/fonts/truetype/noto && \
#    rm NotoSansAdlamUnjoined-hinted.zip && \
#    fc-cache -f -v


#RUN wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansAdlam-hinted.zip && \
#    unzip -o NotoSansAdlam-hinted.zip && \
#    mv *ttf /usr/share/fonts/truetype/noto && \
#    rm NotoSansAdlam-hinted.zip && \
#    fc-cache -f -v


RUN pip3 install --upgrade pip setuptools

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt


RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g carto cartocc


RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY src /opt/app/


EXPOSE 8000

ENV PYTHONUNBUFFERED 1

CMD gunicorn -R -k gevent --log-config logging.conf --log-level DEBUG webapp:app -b :8000

