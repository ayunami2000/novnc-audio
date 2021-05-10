FROM ubuntu:focal-20210401

RUN sudo apt update && \
    sudo apt-get install -y git python3-pip libasound-dev && \
    sudo apt-get install -y portaudio19-dev libportaudio2 libportaudiocpp0 && \
    sudo apt-get install -y ffmpeg

# Clone noVNC.
RUN git clone https://github.com/ayunami2000/noVNC.git ~/noVNC
RUN cp ~/noVNC/vnc.html ~/noVNC/index.html

# websockify
RUN git clone https://github.com/kanaka/websockify ~/noVNC/utils/websockify

# Audio server
RUN pip3 install pyaudio flask
COPY audioserver ~/audioserver
RUN pip3 install -r ~/audioserver/requirements.txt

# RUN NoVNC
COPY supervisord.conf /etc/supervisor/conf.d/zzz_hmihy.conf
#COPY start-vnc.sh /opt/bin/
COPY fluxbox.init /usr/share/fluxbox/init

#Pulse audio
RUN sudo apt-get install -y --no-install-recommends pulseaudio dbus-x11 xserver-xorg-video-dummy; \
    sudo apt-get install -y --no-install-recommends libcairo2 libxcb1 libxrandr2 libxv1 libopus0 libvpx4;

# setup pulseaudio
RUN mkdir -p ~/.config/pulse/; \
    echo "default-server=unix:/tmp/pulseaudio.socket" > ~/.config/pulse/client.conf;

## WebRTC Cli
RUN sudo apt-get install  -y gcc make pkg-config libopus-dev libopusfile-dev libpulse-dev software-properties-common \
    && sudo add-apt-repository ppa:longsleep/golang-backports \
    && sudo apt-get update \
    && sudo apt-get install  -y golang-go

RUN sudo git clone https://github.com/gavv/webrtc-cli.git
RUN cd webrtc-cli && sudo make

# Test webrtc-cli
RUN cd webrtc-cli && sudo ./webrtc-cli -h

EXPOSE 6080 4444 5900 5000
