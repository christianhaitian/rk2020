#!/bin/bash
clear

LOG_FILE="/home/odroid/update3.log"

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

printf "\n\e[32mLet's check and make sure internet connectivity to github exist before starting....\n\n" | tee -a "$LOG_FILE"
sleep 5
sudo ping -c5 -w5 github.com

if [ $? -eq 0 ]; then
  printf "\n\e[32mLooks like we're good to go so we can move on.\n" | tee -a "$LOG_FILE"
  printf "\n\e[91m!!!!!!!!!!!!!!!!!!!!!!!Warning!!!!!!!!!!!!!!!!!!!!!!!!\n\n" | tee -a "$LOG_FILE"
  printf "\e[32mDo not disconnect from the internet until this script is done.\n" | tee -a "$LOG_FILE"
  printf "It's also a good idea to leave your unit plugged in and charging\n" | tee -a "$LOG_FILE"
  printf "as this process may take quite a bit of energy to complete..\n" | tee -a "$LOG_FILE"
  sleep 5
else 
  printf "\n\e[91mEither your internet connection is down, unstable, or github is not responding right now.\n" | tee -a "$LOG_FILE"
  printf "Fix your internet or check back later.\n\n\e[39m" | tee -a "$LOG_FILE"
  sleep 5
  rm -- "$0"
  exit 1
fi

printf "\n\e[93mONCE YOU PROCEED WITH THIS UPDATE SCRIPT, DO NOT STOP THIS SCRIPT\n" | tee -a "$LOG_FILE"
printf "UNTIL IT IS COMPLETED OR THIS DISTRIBUTION MAY BE LEFT\n" | tee -a "$LOG_FILE"
printf "IN A STATE OF UNUSABILITY.  Make sure you've created a backup of this\n" | tee -a "$LOG_FILE"
printf "sd card as a precaution in case something goes very wrong\n" | tee -a "$LOG_FILE"
printf "with this process.  You've been warned!\n\n" | tee -a "$LOG_FILE"
sleep 15

printf "\n\e[93mType 'u' to update or any other key to exit this script.\n\n" | tee -a "$LOG_FILE"
while : ; do
read -n 1 k <&1
printf "$k" >> "$LOG_FILE"
if [[ $k = u ]] ; then
  printf "\n\e[32mStarting...\n\e[32m" | tee -a "$LOG_FILE"
else
  printf "\n\e[93mExiting the program...\n\n\e[39m" | tee -a "$LOG_FILE"
  sleep 3
  rm -- "$0"
  exit 1
fi

printf "\nFirst, let's disable some unneeded systemd services to minimize on random system lags...\n" | tee -a "$LOG_FILE"
sudo systemctl disable rsyslog | tee -a "$LOG_FILE"
sudo systemctl disable logrotate | tee -a "$LOG_FILE"
sudo systemctl mask systemd-journald.service | tee -a "$LOG_FILE"
sudo systemctl mask systemd-journal-flush.service | tee -a "$LOG_FILE"
sudo systemctl disable ModemManager.service | tee -a "$LOG_FILE"
sudo systemctl disable polkit.service | tee -a "$LOG_FILE"
printf "\nNow that that's done, let's move on with the rest of the updates...\n" | tee -a "$LOG_FILE"

printf "\nDownloading and copying daphne and fuse cores to retroarch 64 bit...\n" | tee -a "$LOG_FILE"
wget http://eple.us/retroroller/libretro/aarch64/daphne_libretro.so.zip | tee -a "$LOG_FILE"
wget http://eple.us/retroroller/libretro/aarch64/fuse_libretro.so.zip | tee -a "$LOG_FILE"
tar -C /home/odroid/.config/retroarch/cores -zxvf daphne_libretro.so.zip | tee -a "$LOG_FILE"
tar -C /home/odroid/.config/retroarch/cores -zxvf fuse_libretro.so.zip | tee -a "$LOG_FILE"
rm daphne_libretro.so.zip | tee -a "$LOG_FILE"
rm fuse_libretro.so.zip | tee -a "$LOG_FILE"

printf "\nCreate Daphne and ZX Spectrum rom folders...\n" | tee -a "$LOG_FILE"
sudo mkdir /roms/daphne
sudo mkdir /roms/zxspectrum

printf "\nBackup existing emulationstation systems config and download updated config for Daphne and ZX Spectrum inclusion...\n" | tee -a "$LOG_FILE"
cp /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update3.bak
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/etc/emulationstation/es_systems.cfg -O /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"

printf "\nDownloading and copying updated retroarch 1.9.0 executables...\n" | tee -a "$LOG_FILE"
mv /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.update3.bak
mv /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.update3.bak
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/retroarch -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/retroarch32 -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"

printf "\nFix retroarch display notification size and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/menu_widget_scale.txt -P /home/odroid/ | tee -a "$LOG_FILE"
sed -e '/menu_widget_scale_factor/{r /home/odroid/menu_widget_scale.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
sed -e '/menu_widget_scale_factor/{r /home/odroid/menu_widget_scale.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
mv /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg
mv /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg
sudo rm /home/odroid/menu_widget_scale.txt.txt
sudo chmod 777 /opt/retroarch/bin/retroarch
sudo chmod 777 /opt/retroarch/bin/retroarch32
sudo chmod 777 /home/odroid/.config/retroarch/retroarch.cfg
sudo chmod 777 /home/odroid/.config/retroarch32/retroarch.cfg

printf "\nAdd logging start and stop to options menu...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/opt/"Start Logging Services".sh -O /opt/system/"Start Logging Services.sh" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/opt/"Stop Logging Services".sh -O /opt/system/"Stop Logging Services.sh" | tee -a "$LOG_FILE"
sudo chmod 777 /opt/system/"Stop Logging Services.sh"
sudo chmod 777 /opt/system/"Start Logging Services.sh"

printf "\nVoila! All Done.  You're distro has now been successfully upgraded to TheRA-NTFS version 3\n\n\e[39m" | tee -a "$LOG_FILE"

rm -- "$0"
exit 0
done
