#!/bin/bash

serial=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
for i in /home/pi/images/2020-05-* ; do
	gsutil -m rsync -r $i gs://2020-summer-data/${serial}/`basename $i`
done
