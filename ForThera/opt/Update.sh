#!/bin/bash

LOG_FILE="/home/odroid/esupdate.log"

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

msgbox "ONCE YOU PROCEED WITH THIS UPDATE SCRIPT, DO NOT STOP THIS SCRIPT UNTIL IT IS COMPLETED OR THIS DISTRIBUTION MAY BE LEFT IN A STATE OF UNUSABILITY.  Make sure you've created a backup of this sd card as a precaution in case something goes very wrong with this process.  You've been warned!  Type OK in the next screen to proceed."
my_var=`osk "Enter OK here to proceed." | tail -n 1`

echo "$my_var" | tee -a "$LOG_FILE"

if [[ $my_var = OK ]] || [[ $my_var = ok ]] ; then
  wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/TheraUpdate.sh -O /home/odroid/TheraUpdate.sh -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/TheraUpdate.sh | tee -a "$LOG_FILE"
  sh /home/odroid/TheraUpdate.sh
else
  msgbox "You didn't type OK.  This script will exit now and no changes have been made from this process."
  printf "You didn't type OK.  This script will exit now and no changes have been made from this process." | tee -a "$LOG_FILE"
  exit 1
fi

if [ $? -ne 187 ]; then
  msgbox "There was an error with attempting this update."
  printf "There was an error with attempting this update." | tee -a "$LOG_FILE"
fi
