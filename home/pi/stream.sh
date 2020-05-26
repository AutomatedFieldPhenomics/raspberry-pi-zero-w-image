#!/bin/bash

W=1280
H=720
FPS=25
BW=4000000
G=50

raspivid -o - -t 0 -w $W -h $H -fps $FPS -b $BW -g $G | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/j83k-zd18-3xfy-5c9m

