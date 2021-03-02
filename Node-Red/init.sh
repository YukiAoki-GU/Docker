#!/bin/bash
sudo pigpiod
cd /home/pi
nohup node-red >> /home/pi/nodered.log 2>&1 &
tail -f /dev/null
