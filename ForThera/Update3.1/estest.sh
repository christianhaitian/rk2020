#!/bin/bash
sudo systemctl stop emulationstation
sudo apt update -y
sudo apt-get install -y unzip libboost-system-dev libboost-filesystem-dev libboost-date-time-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libasound2-dev cmake libsdl2-dev libsdl2-mixer-2.0-0
sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.temp92620.bak
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/.emulationstation/es_settings.cfg -O /home/odroid/.emulationstation/es_settings.cfg
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es_systems.cfg -O /etc/emulationstation/es_systems.cfg
sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/es-resources.tar
sudo tar -xf es-resources.tar -C /usr/bin/emulationstation/
sudo rm es-resources.tar
sudo chown odroid:odroid /home/odroid/.emulationstation/es_settings.cfg
sudo chmod -v 777 /home/odroid/.emulationstation/es_settings.cfg
sudo chmod -v 777 /usr/bin/emulationstation/emulationstation
sudo chown odroid:odroid /etc/emulationstation/es_systems.cfg
sudo chmod -v 777 /etc/emulationstation/es_systems.cfg
sudo mkdir /roms/x68000
sudo mkdir /roms/neogeocd
sudo wget http://eple.us/retroroller/libretro/aarch64/neocd_libretro.so.zip
sudo wget http://eple.us/retroroller/libretro/aarch64/duckstation_libretro.so.zip
sudo wget http://eple.us/retroroller/libretro/aarch64/px68k_libretro.so.zip
sudo unzip -n neocd_libretro.so.zip -d /home/odroid/.config/retroarch/cores/
sudo unzip -n duckstation_libretro.so.zip -d /home/odroid/.config/retroarch/cores/
sudo unzip -n px68k_libretro.so.zip -d /home/odroid/.config/retroarch/cores/
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/neocd_libretro.so
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/neocd_libretro.so
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/duckstation_libretro.so
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/duckstation_libretro.so
sudo chmod -v 777 /home/odroid/.config/retroarch/cores/px68k_libretro.so
sudo chown odroid:odroid /home/odroid/.config/retroarch/cores/px68k_libretro.so
sudo rm neocd_libretro.so.zip
sudo rm duckstation_libretro.so.zip
sudo rm px68k_libretro.so.zip
sudo ln -sfv /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.10.0 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0
sudo systemctl start emulationstation
rm -- "$0"
