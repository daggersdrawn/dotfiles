#!/usr/bin/env python2

# dynzoom.py - dynamic zooming for uzbl, based on dynzoom.js
# Usage:
# @on_event GEOMETRY_CHANGED spawn /path/to/dynzoom.py \@geometry 1024 768
# Where 1024x768 is the resolution where we start to zoom out
import os
import re
import sys


def get_geometry(geo):
    " Parses WxH+X+Y into a 4-tuple of ints "
    return map(int, re.match(r"(\d+)x(\d+)[\+-](\d+)[\+-](\d+)", geo).groups())


def calc_zoom(geo, min_width, min_height):
    " Calculate the zoom level "
    width, height, x, y = get_geometry(geo)
    w = min(1, width/float(min_width))
    h = min(1, height/float(min_height))
    return (w + h)/2


def set_zoom(fifo, level):
    " Set the zoom level "
    with open(fifo, "w") as f:
        f.write("set zoom_level = %f\n" % level)


if __name__ == "__main__":
    set_zoom(os.environ["UZBL_FIFO"], calc_zoom(*sys.argv[1:4]))
