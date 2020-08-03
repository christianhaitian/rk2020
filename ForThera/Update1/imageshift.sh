#!/bin/bash
image=$(ls /boot/BMPs/ | shuf -n 1)
source /home/odroid/.config/shifttest.txt
while [ "$image" = "$lastimage" ]
do
  image=$(ls /boot/BMPs/ | shuf -n 1)
done
rm /home/odroid/.config/shifttest.txt
echo lastimage=$image >> /home/odroid/.config/shifttest.txt
cp /boot/BMPs/$image /boot/logo.bmp

