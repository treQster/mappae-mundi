import io
import logging
from math import pi, sin, log, exp, atan

import flask
import mapnik

app = flask.Flask(__name__)

app.debug = True


logger = logging.getLogger()

TILE_SIZE = 256
MAX_ZOOM = 22
MAP_FILE = '/map/mapnik.xml'

mapnik.logger.set_severity(mapnik.severity_type.Debug)

m = mapnik.Map(TILE_SIZE, TILE_SIZE)
mapnik.load_map(m, MAP_FILE, True)


DEG_TO_RAD = pi/180
RAD_TO_DEG = 180/pi


def minmax(a, b, c):
    a = max(a, b)
    a = min(a, c)
    return a


class TileProjection:
    """
    A tile projection helper.
    Borrowed from somewhere.
    TODO: give credits!
    """
    def __init__(self, levels=18):
        self.Bc = []
        self.Cc = []
        self.zc = []
        self.Ac = []
        c = 256
        for d in range(0, levels):
            e = c / 2;
            self.Bc.append(c / 360.0)
            self.Cc.append(c / (2 * pi))
            self.zc.append((e, e))
            self.Ac.append(c)
            c *= 2

    def fromLLtoPixel(self, ll, zoom):
        d = self.zc[zoom]
        e = round(d[0] + ll[0] * self.Bc[zoom])
        f = minmax(sin(DEG_TO_RAD * ll[1]), -0.9999, 0.9999)
        g = round(d[1] + 0.5 * log((1 + f) / (1 - f)) * -self.Cc[zoom])
        return (e, g)

    def fromPixelToLL(self, px, zoom):
        e = self.zc[zoom]
        f = (px[0] - e[0]) / self.Bc[zoom]
        g = (px[1] - e[1]) / -self.Cc[zoom]
        h = RAD_TO_DEG * (2 * atan(exp(g)) - 0.5 * pi)
        return (f, h)


map_projection = mapnik.Projection(m.srs)
tile_projection = TileProjection(MAX_ZOOM + 1)


def render_tile(x, y, z, scale):
    assert scale > 0, "Scale should be positive"
    # Calculate pixel positions of bottom-left & top-right
    p0 = (x * 256, (y + 1) * 256)
    p1 = ((x + 1) * 256, y * 256)

    # Convert to LatLong (EPSG:4326)
    l0 = tile_projection.fromPixelToLL(p0, z)
    l1 = tile_projection.fromPixelToLL(p1, z)

    # Convert to map projection (e.g. mercator co-ords EPSG:900913)
    c0 = map_projection.forward(mapnik.Coord(l0[0], l0[1]))
    c1 = map_projection.forward(mapnik.Coord(l1[0], l1[1]))

    logger.debug("Zooming to box {} {} {} {}".format(c0.x, c0.y, c1.x, c1.y))

    bbox = mapnik.Box2d(c0.x, c0.y, c1.x, c1.y)

    print(bbox)

    render_size = int(TILE_SIZE * scale)
    m.resize(render_size, render_size)
    m.zoom_to_box(bbox)
    if m.buffer_size < 1280:
        m.buffer_size = 1280

    # m.zoom_all()

    # Render image with default Agg renderer
    im = mapnik.Image(render_size, render_size)
    mapnik.render(m, im, scale)
    return im
    #
    # byte_io = io.BytesIO()
    # mapnik.render(m, byte_io, 'png')
    # byte_io.seek(0)
    # return byte_io


@app.route('/<style>/<z>/<x>/<y>.<ext>')
@app.route('/<style>/<z>/<x>/<y>@<scale>.<ext>')
@app.route('/<style>/<z>/<x>/<y>@<scale>x.<ext>')
def index(style, z, x, y, ext, scale=1):
    scale = float(scale)
    logger.info("About to render tile for {} {} {} {} @ {} .{}".format(style, z, x, y, scale, ext))
    image = render_tile(int(x), int(y), int(z), scale)
    filename = '/tmp/{}-{}-{}-{}@{}.{}'.format(style, z, x, y, scale, ext)
    image.save(filename)
    # return flask.send_file(io.BytesIO(image.tostring()), mimetype='image/png')
    return flask.send_file(filename, mimetype='image/{}'.format(ext))


__all__ = ['app']
