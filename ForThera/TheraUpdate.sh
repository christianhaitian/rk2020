#!/bin/bash
clear

UPDATE_DATE="10172020-2"
LOG_FILE="/home/odroid/update$UPDATE_DATE.log"
UPDATE_DONE="/home/odroid/.config/testupdate$UPDATE_DATE"

if [ -f "$UPDATE_DONE" ]; then
  msgbox "No more updates available.  Check back later."
  rm -- "$0"
  exit 187
fi

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

if [ ! -f "/home/odroid/.config/update10162020-1" ]; then

printf "\nInstalling Atari800 fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/Atari800sep.tar -a "$LOG_FILE"
sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
sudo tar -vxf Atari800sep.tar --strip-components=1 -C / | tee -a "$LOG_FILE"
sudo rm -v Atari800sep.tar | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/Atari800/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
msgbox "Updates have been completed.  Hit A to go back to Emulationstation."
touch "$UPDATE_DONE"
rm -v -- "$0" | tee -a "$LOG_FILE"
sudo systemctl restart emulationstation
exit 187

elif [ ! -f "$UPDATE_DONE" ]; then
printf "\nLet's get some wolfenstein 3D in here...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/ecwolf.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/ecwolf_libretro.so.zip -a "$LOG_FILE"
sudo unzip -o ecwolf.zip -d /roms/ | tee -a "$LOG_FILE"
sudo unzip -n ecwolf_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
sudo rm -v ecwolf_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v ecwolf.zip | tee -a "$LOG_FILE"
msgbox "Atari800 fix update have been applied and as an added bonus, you can now run the Wolfenstein 3D port. Hit A to go back to Emulationstation."
touch "$UPDATE_DONE"
rm -v -- "$0" | tee -a "$LOG_FILE"
sudo systemctl restart emulationstation
exit 187

else 
msgbox "No more updates available.  Check back later."
rm -- "$0"
exit 187
fi