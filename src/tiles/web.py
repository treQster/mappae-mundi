import io
import logging

import flask

from tiles import config
from tiles import render

app = flask.Flask(__name__)
app.config.from_object(config)
app.debug = config.DEBUG

logger = logging.getLogger(__name__)


@app.route('/<z>/<x>/<y>.<ext>')
@app.route('/<z>/<x>/<y>@<scale>x.<ext>')
def index(z, x, y, ext, scale=1):
    scale = float(scale)
    logger.info("About to render tile for {}/{}/{}/@{}x.{}".format(z, x, y, scale, ext))
    image = render.render_tile(int(x), int(y), int(z), scale)
    filename = '/tmp/{}-{}-{}-{}@{}x.{}'.format("tile", z, x, y, scale, ext)
    image.save(filename)
    # return flask.send_file(io.BytesIO(image.tostring()), mimetype='image/png')
    return flask.send_file(filename, mimetype='image/{}'.format(ext))


__all__ = ['app']
