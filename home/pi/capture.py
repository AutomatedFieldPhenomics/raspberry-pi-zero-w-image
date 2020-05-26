#!/usr/bin/env python3

from picamera import PiCamera
from time import sleep
import datetime
import os

camera = PiCamera()
camera.resolution = (720, 480)
camera.rotation = 180

# start preview seems to be necessary for white balance and auto exposure
camera.start_preview()
sleep(2)

now = datetime.datetime.now()

dir = "images/%s" % now.strftime("%Y-%m-%d")
if not os.path.exists(dir):
    os.makedirs(dir)

camera.capture('%s/%s.png' % (dir, now.strftime("%H:%M:%S")))

camera.stop_preview()
