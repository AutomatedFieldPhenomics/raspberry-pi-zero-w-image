#!/usr/bin/env python3

import json
import requests
import datetime
import os

now = datetime.datetime.now()

dir = "images/%s" % now.strftime("%Y-%m-%d")
if not os.path.exists(dir):
    os.makedirs(dir)

# Enter your OpenWeatherMap API key here
api_key = "f8685ff5fdb2881d8b10100e840926e8"

# base_url variable to store url
base_url = "http://api.openweathermap.org/data/2.5/forecast?"

# Give city name
city_name = "Winnipeg, CA"

# complete_url variable to store complete url address
complete_url = base_url + "appid=" + api_key + "&q=" + city_name

# get method of requests module return response object
response = requests.get(complete_url)

# json method of response object convert json format data into python format data
r = response.json()

# store json to file
with open('%s/%s.json' % (dir, now.strftime("%H:%M:%S")), 'w') as file:
    json.dump(r, file)
