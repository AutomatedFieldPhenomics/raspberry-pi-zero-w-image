#!/usr/bin/env python3

from python_tsl2591 import tsl2591
import os
import datetime
import csv

csvFile = 'lightlux.csv'

# Take lux measurment
tsl = tsl2592()
full, ir = tsl.get_full_luminosity()
lux = tsl.calculate_lux(full, ir)

# Get date and time
now = datetime.datetime.now()
date = now.strftime("%Y-%m-%d")
time = now.strftime("%H:%M:%S")

# Create CSV header if one does not already exist
firstRow = "Lux, Full, IR, Date (ymd), Time\n"
if not os.access(csvFile, os.F_OK):
    with open(csvFile, 'a') as fd:
        fd.write(firstRow)

# Append data to CSV
currentRow = "{L},{F},{I},{D},{t}\n".format(L=lux, F=full, I=ir, D=date, t=time)
with open(csvFile, 'a') as fd:
    fd.write(currentRow)
