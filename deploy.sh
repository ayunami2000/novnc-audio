#!/bin/bash

export SEL_PORT=4445
export NOVNC_PORT=6081
export AUDIO_PORT=5001
export VNC=5900

docker build -t ayunami2000/novnc-audio .

docker rm -f novnc-audio
docker run -it --name novnc-audio -p $NOVNC_PORT:6080 -p $SEL_PORT:4444 -p $AUDIO_PORT:5000 -p $VNC:5900 -v /dev/shm:/dev/shm --privileged --cap-add=ALL -it -v /dev:/dev -v /lib/modules:/lib/modules ayunami2000/novnc-audio
