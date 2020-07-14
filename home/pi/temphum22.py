#!/usr/bin/env python3

# For use with a DHT22 sensor

import Adafruit_DHT as dht
import datetime
import os
import csv

# Get file or create if it does not exist
csvFile = 'THstats22.csv'
firstRow = 'Temperature [C], Humidity [%], Date [ymd], Time\n'

if not os.access(csvFile, os.F_OK):
    with open(csvFile, 'a') as fd:
        fd.write(firstRow)

# Get the date and time
now = datetime.datetime.now()
date = now.strftime("%Y-%m-%d")
time = now.strftime("%H:%M:%S")

# Read data from sensor
DHT = 22
hum, temp = dht.read_retry(dht.DHT22, DHT)

# Append data to csv
currentRow = '{T},{H},{D},{t}\n'.format(T=temp, H=hum, D=date, t=time)
with open(csvFile, 'a') as fd:
    fd.write(currentRow)
