# Base image (http://ftp.jaist.ac.jp/pub/raspberrypi/raspios_lite_armhf/root.tar.xz)
FROM aoki335/raspios-lite_armhf
MAINTAINER Yuki Aoki

LABEL version="1.0"
LABEL description="Node-Red"

RUN apt-get -y update
RUN apt-get -y upgrade

# Basic install for Python3
RUN apt-get -y install python3-dev build-essential python3-pip libatlas-base-dev python3-distutils

# Install of pigpiod
WORKDIR /opt
RUN wget --output-document=download.zip https://github.com/joan2937/pigpio/archive/master.zip
RUN unzip download.zip
RUN rm download.zip
WORKDIR /opt/pigpio-master
RUN make
RUN make install

# For node-red-contrib-opencv
RUN apt-get -y install libopencv-dev

# For picamera
RUN apt-get -y install python3-picamera
RUN pip3 install rpi.gpio

# Setting of locale 
RUN echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen

# Add pi user as sudo user
RUN echo 'pi:iot-school' | chpasswd
RUN echo 'pi    ALL=(ALL)       ALL' >> /etc/sudoers
RUN echo 'pi ALL=NOPASSWD: ALL' >> /etc/sudoers
# Change to pi user
USER pi

# Install Node-Red
WORKDIR /home/pi
RUN wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered
RUN echo y | bash update-nodejs-and-nodered
RUN rm update-nodejs-and-nodered

#Fix setting of Node-red
COPY settings.js .node-red/

# Install nodes
WORKDIR /home/pi/.node-red
RUN npm install node-red-contrib-camerapi \
node-red-contrib-image-output \
node-red-contrib-python-function \
node-red-dashboard \
node-red-node-base64 \
node-red-contrib-aedes \
node-red-node-pi-mcp3008 \
node-red-contrib-opencv \
#node-red-node-pi-gpiod \
node-red-node-pi-gpio

RUN npm audit fix

# Fix setting of node-red-contrib-camerapi
COPY camerapi.js /home/pi/.node-red/node_modules/node-red-contrib-camerapi/

# Fix setting of node-red-contrib-python-function
COPY python-function.js /home/pi/.node-red/node_modules/node-red-contrib-python-function/lib/

# 8888 is for pigpio, 1883 is for MQTT 
EXPOSE 1880 
EXPOSE 1883 
EXPOSE 8888 


WORKDIR /home/pi
COPY init.sh /home/pi/init.sh
ENTRYPOINT ["/home/pi/init.sh"]
