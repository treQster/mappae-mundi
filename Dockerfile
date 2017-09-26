FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    python3  \
    libmapnik3.0 mapnik-utils\
    python3-mapnik python3-pip

# Install fonts needed for rendering
RUN apt-get install -y fontconfig \
    fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont ttf-hanazono

RUN apt-get install -y wget unzip

RUN wget https://noto-website.storage.googleapis.com/pkgs/NotoEmoji-unhinted.zip && \
    unzip NotoEmoji-unhinted.zip && \
    mv *ttf /usr/share/fonts/truetype/noto && \
    rm NotoEmoji-unhinted.zip && \
    fc-cache -f -v

RUN pip3 install --upgrade pip

COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY src/ /opt/app/

VOLUME /data
#RUN python3 /opt/app/get-shapefiles.py --no-curl -f

EXPOSE 8000

ENV PYTHONUNBUFFERED 1

CMD gunicorn -R -k gevent --log-config logging.conf --log-level DEBUG webapp:app -b :8000
