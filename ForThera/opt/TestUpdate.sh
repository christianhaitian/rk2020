#!/bin/bash

LOG_FILE="/home/odroid/testesupdate.log"

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/TestTheraUpdate.sh -O /home/odroid/TestTheraUpdate.sh -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/TestTheraUpdate.sh | tee -a "$LOG_FILE"
sh /home/odroid/TestTheraUpdate.sh

if [ $? -ne 187 ]; then
  msgbox "There was an error with attempting this test update."
  printf "There was an error with attempting this test update." | tee -a "$LOG_FILE"
fi
