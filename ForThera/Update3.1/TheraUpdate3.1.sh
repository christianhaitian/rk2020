#!/bin/bash
clear

UPDATE_VER="3.1"
LOG_FILE="/home/odroid/update$UPDATE_VER.log"
UPDATE_DONE="/home/odroid/.config/testupdate$UPDATE_VER"

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

printf "\nWorkaround for occassional retroarch hotkey issue and related file permissions...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/chng_gamepadbtn.txt -O /home/odroid/chng_gamepadbtn.txt
if [ $? -eq 0 ]; then
  sed -e '/input_menu_toggle_gamepad_combo/{r /home/odroid/chng_gamepadbtn.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
  sed -e '/input_menu_toggle_gamepad_combo/{r /home/odroid/chng_gamepadbtn.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
  mv -v /home/odroid/.config/retroarch/retroarch.cfg /home/odroid/.config/retroarch/retroarch.update$UPDATE_VER.bak
  mv -v /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.update$UPDATE_VER.bak
  mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  mv -v /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo rm -v /home/odroid/chng_gamepadbtn.txt | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
  sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
else
  printf "Can't download necessary github file.  Check your internet connection and try again." | tee -a "$LOG_FILE"
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

printf "\nUpdated Rertroarch 1.9.0 with RGA Scaling...\n" | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
mv -v /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/retroarch -O /opt/retroarch/bin/retroarch -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch32/retroarch32 -O /opt/retroarch/bin/retroarch32 -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/chng_viddrv.txt -O /home/odroid/chng_viddrv.txt -a "$LOG_FILE"
sed -e '/video_driver/{r /home/odroid/chng_viddrv.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
mv -v /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo rm -v /home/odroid/chng_viddrv.txt | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
sudo chmod -v 777 /opt/retroarch/bin/retroarch32 | tee -a "$LOG_FILE"
sudo ln -sfv /usr/lib/aarch64-linux-gnu/librga.so /usr/lib/aarch64-linux-gnu/librga.so.2 | tee -a "$LOG_FILE"

printf "\nFix analog stick not responding in N64 games and Mame2003 with no control ...\n" | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch/retroarch-core-options.cfg /home/odroid/.config/retroarch/retroarch-core-options.cfg.update$UPDATE_VER.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch-core-options.cfg /home/odroid/.config/retroarch32/retroarch-core-options.cfg.update$UPDATE_VER.bak | tee -a "$LOG_FILE"
mv -v /home/odroid/.config/retroarch32/retroarch.cfg /home/odroid/.config/retroarch32/retroarch.cfg.update$UPDATE_VER.bak | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/retroarch-core-options.cfg -O /home/odroid/.config/retroarch/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch32/retroarch-core-options.cfg -O /home/odroid/.config/retroarch32/retroarch-core-options.cfg -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch32/retroarch.cfg -O /home/odroid/.config/retroarch32/retroarch.cfg -a "$LOG_FILE"
wget -N https://github.com/christianhaitian/rgb10/raw/master/ForThera/retroarch32/config/ParaLLEl%20N64/ParaLLEl%20N64.rmp -P "/home/odroid/.config/retroarch32/config/remaps/ParaLLEl N64" -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch32/config/remaps/ -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch-core-options.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch32/retroarch.cfg | tee -a "$LOG_FILE"

printf "\nDownload and install updated Emulationstation...\n" | tee -a "$LOG_FILE"
sudo systemctl stop emulationstation
sudo apt-get install -y fonts-droid-fallback unzip libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0 | tee -a "$LOG_FILE"
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.update$UPDATE_VER.bak | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation-fcamod/.emulationstation/es_settings.cfg -O /home/odroid/.emulationstation/es_settings.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation-fcamod/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation-fcamod/es-resources.tar -a "$LOG_FILE"
sudo tar -vxf es-resources.tar -C /usr/bin/emulationstation/ | tee -a "$LOG_FILE"
sudo rm -v es-resources.tar | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.emulationstation/es_settings.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.emulationstation/es_settings.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
sudo chown odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo chmod -v 777 /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
sudo mkdir -v /roms/x68000 | tee -a "$LOG_FILE"
sudo mkdir -v /roms/neogeocd | tee -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/neocd_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/duckstation_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/px68k_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/tgbdual_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/fbalpha2012_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/picodrive_libretro.so.zip -a "$LOG_FILE"
wget -O ~/.asoundrc https://www.batocera.org/users/lbrpdx/asoundrc -a "$LOG_FILE"
sudo unzip -n neocd_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n duckstation_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n px68k_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n tgbdual_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n fbalpha2012_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n picodrive_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/neocd_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/duckstation_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/px68k_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/tgbdual_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/tgbdual_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/fbalpha2012_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/fbalpha2012_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/picodrive_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/picodrive_libretro.so | tee -a "$LOG_FILE"
sudo rm -v neocd_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v duckstation_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v px68k_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v tgbdual_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v fbalpha2012_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v picodrive_libretro.so.zip | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/Freeplay9-30-v1.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/Switch.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/es-theme-theRA_NTFS-carbon.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/es-theme-super-retro-rk3326.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/es-theme-gbz35-mod.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/dosirakF.zip -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/es-theme-minimal.zip -a "$LOG_FILE"
sudo unzip -o Freeplay9-30-v1.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o Switch.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-theRA_NTFS-carbon.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-super-retro-rk3326.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-gbz35-mod.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o dosirakF.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo unzip -o es-theme-minimal.zip -d /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo rm -v Freeplay9-30-v1.zip | tee -a "$LOG_FILE"
sudo rm -v Switch.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-theRA_NTFS-carbon.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-super-retro-rk3326.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-gbz35-mod.zip | tee -a "$LOG_FILE"
sudo rm -v dosirakF.zip | tee -a "$LOG_FILE"
sudo rm -v es-theme-minimal.zip | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid ~/.asoundrc | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /etc/emulationstation/
sudo systemctl start emulationstation

printf "\nDownloading and copying new logos to /boot/BMPs...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/boot/BMPs/logoRL.bmp -O /boot/BMPs/logoRL.bmp | tee -a "$LOG_FILE"

printf "\nFix Genuine check menu option...\n" | tee -a "$LOG_FILE"
sudo rm -v /opt/system/"RK2020 Genuine Check.sh" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/system/RK2020%20Genuine%20Check.sh -O /opt/system/"RK2020 Genuine Check.sh" | tee -a "$LOG_FILE"
sudo chmod 775 /opt/system/"RK2020 Genuine Check.sh"
sudo chown odroid:odroid /opt/system/"RK2020 Genuine Check.sh"

printf "\nFix Quake shortcut option...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/ports/Quake.sh -O /roms/ports/Quake.sh | tee -a "$LOG_FILE"

printf "\nAtari800 bios file location and default controller fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/home/odroid/.atari800.cfg -O /home/odroid/.atari800.cfg -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/retroarch/config/remaps/Atari800.zip -a "$LOG_FILE"
sudo unzip -o Atari800.zip -d /home/odroid/.config/retroarch/config/remaps/ | tee -a "$LOG_FILE"
sudo rm -v Atari800.zip | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"

printf "\nAdd support for Cannonball, Cavestory, Doom, Doom2 and Rick Dangerous...\n" | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/ports.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/prboom_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/nxengine_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/cannonball_libretro.so.zip -a "$LOG_FILE"
sudo wget http://eple.us/retroroller/libretro/aarch64/xrick_libretro.so.zip -a "$LOG_FILE"
sudo unzip -o ports.zip -d /roms/ | tee -a "$LOG_FILE"
sudo unzip -n prboom_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n nxengine_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n cannonball_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo unzip -n xrick_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/prboom_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/prboom_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/nxengine_libretro.so | tee -a "$LOG_FILE"
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/nxengine_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/cannonball_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/cannonball_libretro.so | tee -a "$LOG_FILE"
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/xrick_libretro.so | tee -a "$LOG_FILE"
sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/xrick_libretro.so | tee -a "$LOG_FILE"
sudo rm -v prboom_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v nxengine_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v cannonball_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v xrick_libretro.so.zip | tee -a "$LOG_FILE"
sudo rm -v ports.zip | tee -a "$LOG_FILE"

printf "\nInstall updated kernel with wifi sleep fix...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/BootFileUpdates.tar.gz -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/KernelUpdate.tar.gz -a "$LOG_FILE"
sudo tar --same-owner -zxvf BootFileUpdates.tar.gz -C / | tee -a "$LOG_FILE"
sudo tar --same-owner -zxvf KernelUpdate.tar.gz -C / | tee -a "$LOG_FILE"
sudo rm -v BootFileUpdates.tar.gz | tee -a "$LOG_FILE"
sudo rm -v KernelUpdate.tar.gz | tee -a "$LOG_FILE"

printf "\nLast but not least, let's ensure that Drastic performance has not been negatively impacted by these updates...\n" | tee -a "$LOG_FILE"
sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.10.0 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0 | tee -a "$LOG_FILE"

printf "\nVoila! All Done.  You're distro has now been successfully upgraded to TheRA-NTFS version 3.1.  System will now reboot so the kernel updates can take effect.\n\n\e[39m" | tee -a "$LOG_FILE"
sleep 6
rm -v -- "$0" | tee -a "$LOG_FILE"
sudo reboot
exit 0
done
