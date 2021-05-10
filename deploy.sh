#!/bin/bash

export ENVIRONMENT=${1:-dev}
export SEL_PORT=4445
export NOVNC_PORT=6081
export AUDIO_PORT=5001
export VNC=5900

if [ "dev" == "$ENVIRONMENT" ]; then
  export SEL_PORT=4444
  export NOVNC_PORT=6080
  export AUDIO_PORT=5000
  export VNC=5901
fi

docker build -t helppery/selenium-novnc-audio-$ENVIRONMENT .

docker rm -f selenium-novnc-audio-$ENVIRONMENT
docker run -d --name selenium-novnc-audio-$ENVIRONMENT -p $NOVNC_PORT:6080 -p $SEL_PORT:4444 -p $AUDIO_PORT:5000 -p $VNC:5900 -v /dev/shm:/dev/shm --privileged --cap-add=ALL -it -v /dev:/dev -v /lib/modules:/lib/modules helppery/selenium-novnc-audio-$ENVIRONMENT
