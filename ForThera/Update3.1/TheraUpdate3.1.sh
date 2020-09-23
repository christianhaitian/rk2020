#!/bin/bash
clear

LOG_FILE="/home/odroid/update3.1.log"

if [ -f "$LOG_FILE" ]; then
  sudo rm "$LOG_FILE"
fi

printf "\n\e[32mLet's check and make sure internet connectivity to github exist before starting....\n\n" | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid "$LOG_FILE" | tee -a "$LOG_FILE"
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

printf "\nInstalling the base vlc files to allow video snaps to play in emulationstation...\n" | tee -a "$LOG_FILE"
sudo apt update -y | tee -a "$LOG_FILE"
sudo apt -y install vlc-plugin-base | tee -a "$LOG_FILE"

printf "\nDownloading and installing Update script to options menu...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/opt/Update.sh -O /opt/system/Update.sh -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/system/Update.sh | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/system/Update.sh | tee -a "$LOG_FILE"

printf "\nDownloading and installing updated dtb files to allow lower cpu downclocks and fix original OGA 1.0 booting ...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/boot/rk3326-odroidgo2-linux.dtb -O /boot/rk3326-odroidgo2-linux.dtb -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/boot/rk3326-odroidgo2-linux-v11.dtb -O /boot/rk3326-odroidgo2-linux-v11.dtb -a "$LOG_FILE"

printf "\nFix analog stick not responding in N64 games and Mame2003 with no control ...\n" | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch/retroarch-core-options.cfg /home/odroid/.config/retroarch/retroarch-core-options.cfg.update3.1.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch-core-options.cfg /home/odroid/.config/retroarch32/retroarch-core-options.cfg.update3.1.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/retroarch-core-options.cfg -O /home/odroid/.config/retroarch/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch32/retroarch-core-options.cfg -O /home/odroid/.config/retroarch32/retroarch-core-options.cfg -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch-core-options.cfg
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch-core-options.cfg
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch-core-options.cfg
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch-core-options.cfg






rm -v fuse_libretro.so.zip | tee -a "$LOG_FILE"
rm -v fmsx_libretro.so.zip | tee -a "$LOG_FILE"

printf "\nCreate ZX Spectrum rom folders and copy remap files for fuse and fmsx...\n" | tee -a "$LOG_FILE"
mkdir -v /roms/zxspectrum | tee -a "$LOG_FILE"
mkdir -v /home/odroid/.config/retroarch/config/remaps/fuse | tee -a "$LOG_FILE"
mkdir -v /home/odroid/.config/retroarch/config/remaps/fMSX | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/config/remaps/fuse | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/config/remaps/fMSX | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/fuse/fuse.rmp -O /home/odroid/.config/retroarch/config/remaps/fuse/fuse.rmp | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/fMSX/fMSX.rmp -O /home/odroid/.config/retroarch/config/remaps/fMSX/fMSX.rmp | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/config/remaps/fuse/fuse.rmp | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/config/remaps/fMSX/fMSX.rmp | tee -a "$LOG_FILE"

printf "\nBackup existing emulationstation systems config and download updated config for ZX Spectrum inclusion...\n" | tee -a "$LOG_FILE"
cp -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update3.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/etc/emulationstation/es_systems.cfg -O /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"

printf "\nDownloading and copying updated retroarch 1.9.0 executables and setting permissions...\n" | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.update3.bak | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.update3.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/retroarch -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/retroarch/retroarch32 -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"

printf "\nFix retroarch display notification size and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/menu_widget_scale.txt -P /home/odroid/ | tee -a "$LOG_FILE"
sed -e '/menu_widget_scale_factor/{r /home/odroid/menu_widget_scale.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
sed -e '/menu_widget_scale_factor/{r /home/odroid/menu_widget_scale.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
sudo rm -v /home/odroid/menu_widget_scale.txt | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"

printf "\nMove location of PPSSPP saves to roms psp folder...\n" | tee -a "$LOG_FILE"
cp -rfv /home/odroid/.config/ppsspp/ /roms/psp | tee -a "$LOG_FILE"
rm -rfv /home/odroid/.config/ppsspp/ | tee -a "$LOG_FILE"
ln -sv /roms/psp/ppsspp/ /home/odroid/.config/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/ppsspp/ | tee -a "$LOG_FILE"

printf "\nMove location of Drastic saves to roms nds folder...\n" | tee -a "$LOG_FILE"
cp -rfv /opt/drastic/cheats/ /roms/nds | tee -a "$LOG_FILE"
cp -rfv /opt/drastic/backup/ /roms/nds | tee -a "$LOG_FILE"
cp -rfv /opt/drastic/savestates/ /roms/nds | tee -a "$LOG_FILE"
cp -rfv /opt/drastic/slot2/ /roms/nds | tee -a "$LOG_FILE"
rm -rfv /opt/drastic/cheats/ | tee -a "$LOG_FILE"
rm -rfv /opt/drastic/backup/ | tee -a "$LOG_FILE"
rm -rfv /opt/drastic/savestates/ | tee -a "$LOG_FILE"
rm -rfv /opt/drastic/slot2/ | tee -a "$LOG_FILE"
ln -sv /roms/nds/backup/ /opt/drastic/ | tee -a "$LOG_FILE"
ln -sv /roms/nds/savestates/ /opt/drastic/ | tee -a "$LOG_FILE"
ln -sv /roms/nds/cheats/ /opt/drastic/ | tee -a "$LOG_FILE"
ln -sv /roms/nds/slot2/ /opt/drastic/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/drastic/backup/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/drastic/savestates/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/drastic/cheats/ | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/drastic/slot2/ | tee -a "$LOG_FILE"

printf "\nAdd logging start and stop to options menu...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/opt/Start%20Logging%20Services.sh -O /opt/system/"Start Logging Services.sh" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3/opt/Stop%20Logging%20Services.sh -O /opt/system/"Stop Logging Services.sh" | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/system/"Stop Logging Services.sh" | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/system/"Start Logging Services.sh" | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/system/"Stop Logging Services.sh" | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/system/"Start Logging Services.sh" | tee -a "$LOG_FILE"

printf "\nVoila! All Done.  You're distro has now been successfully upgraded to TheRA-NTFS version 3\n\n\e[39m" | tee -a "$LOG_FILE"

rm -v -- "$0" | tee -a "$LOG_FILE"
exit 0
done
