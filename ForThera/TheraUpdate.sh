#!/bin/bash
clear

UPDATE_DATE="10292020"
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

c_brightness="$(cat /sys/devices/platform/backlight/backlight/backlight/brightness)"
sudo chmod 666 /dev/tty1
echo 255 > /sys/devices/platform/backlight/backlight/backlight/brightness
touch $LOG_FILE
tail -f $LOG_FILE >> /dev/tty1 &

if [ ! -f "/home/odroid/.config/testupdate10172020-1" ]; then

	printf "\nInstalling Atari800 fix...\n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/Atari800sep.tar -a "$LOG_FILE"
	sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo tar -vxf Atari800sep.tar --strip-components=1 -C / | tee -a "$LOG_FILE"
	sudo rm -v Atari800sep.tar | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/Atari800/ | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid -R /home/odroid/.config/retroarch/config/remaps/Atari800/ | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid -R /home/odroid/.atari800.cfg | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	msgbox "Atari800 workaround for 800, 5200, and XEGS has been applied.  Hit A to go back to Emulationstation."
	touch "/home/odroid/.config/testupdate10172020-1"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10172020-2" ]; then
	printf "\nLet's get some wolfenstein 3D in here...\n" | tee -a "$LOG_FILE"
	wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/ecwolf.zip -a "$LOG_FILE"
	wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/ecwolf_libretro.so.zip -a "$LOG_FILE"
	sudo unzip -o ecwolf.zip -d /roms/ | tee -a "$LOG_FILE"
	sudo unzip -n ecwolf_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
	sudo chmod -v 777 /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/ecwolf_libretro.so | tee -a "$LOG_FILE"
	sudo rm -v ecwolf_libretro.so.zip | tee -a "$LOG_FILE"
	sudo rm -v ecwolf.zip | tee -a "$LOG_FILE"
	msgbox "Wolfenstein 3D port has been added. Hit A to go back to Emulationstation."
	touch "/home/odroid/.config/testupdate10172020-2"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10192020" ]; then
	printf "\nAllow the ability to quit Emulationstation...\n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rgb10/raw/master/ForThera/emulationstation-fcamod/emulationstation.service -O /etc/systemd/system/emulationstation.service -a "$LOG_FILE"
	sudo systemctl daemon-reload
	msgbox "You can now quit EmulationStation.  This could be handy if you want to access a terminal via keyboard by doing alt-f2 or alt-f3 for testing or debugging purposes."
	touch "/home/odroid/.config/testupdate10192020"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10192020-1" ]; then
	printf "\nFix flycast 64bit default configuration save issue\n" | tee -a "$LOG_FILE"
	sudo mv -v /home/odroid/.config/retroarch/config/Flycast/Flycast.cfg /home/odroid/.config/retroarch/config/Flycast/Flycast.cfg.$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/config/Flycast/Flycast.cfg.$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	msgbox "An issue with flycast 64bit being able to save to the default configuration file has been fixed."
	touch "/home/odroid/.config/testupdate10192020-1"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10202020" ]; then
	printf "\nAdd option to use PPSSPP retroarch core\n" | tee -a "$LOG_FILE"
	sudo wget http://eple.us/retroroller/libretro/aarch64/ppsspp_libretro.so.zip -a "$LOG_FILE"
	sudo unzip -n ppsspp_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
	sudo chmod -v 777 /home/odroid/.config/retroarch/cores/ppsspp_libretro.so | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/ppsspp_libretro.so | tee -a "$LOG_FILE"
	sudo rm -v ppsspp_libretro.so.zip | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/ppsspp-options/ppsspp.sh -O /usr/local/bin/ppsspp.sh -a "$LOG_FILE"
	sudo chmod -v 777 /usr/local/bin/ppsspp.sh | tee -a "$LOG_FILE"
	sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/ppsspp-options/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	msgbox "You now have the option to select retroarch for playing PSP games.  Restart EmulationStation in order enable this new feature."
	touch "/home/odroid/.config/testupdate10202020"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10222020" ]; then
	printf "\nAdd option to use Mednafen_PCE or Mednafen_supergrafx retroarch core for increased accuracy and compatibility\n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mednafen_pce/mednafen_pce_libretro.so -O /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so -a "$LOG_FILE"
	sudo chmod -v 777 /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so | tee -a "$LOG_FILE"
	sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mednafen_pce/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	msgbox "You now have the option to select Mednafen_PCE retroarch core for PCE/TG-16 games.  Restart EmulationStation in order enable this new feature."
	touch "/home/odroid/.config/testupdate10222020"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10252020" ]; then
	printf "\nAdd updated Emulationstation with power icon\n" | tee -a "$LOG_FILE"
	sudo mv -v /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/emulationstation-fcamod/emulationstation -O /usr/bin/emulationstation/emulationstation -a "$LOG_FILE"
	sudo chmod -v 777 /usr/bin/emulationstation/emulationstation | tee -a "$LOG_FILE"
	msgbox "Updated Emulationstation with power icon added when plugged to charger.  You'll need to restart Emulationstation in order for this update to take effect."
	touch "/home/odroid/.config/testupdate10252020"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "/home/odroid/.config/testupdate10252020" ]; then
	printf "\nAdd support for standalone N64 emulator\n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/InputAutoCfg.ini -O /opt/mupen64plus/InputAutoCfg.ini -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/mupen64plus-input-sdl.so -O /opt/mupen64plus/mupen64plus-input-sdl.so -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/mupen64plus.cfg -O /home/odroid/.config/mupen64plus/mupen64plus.cfg -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/libmupen64plus.so.2.0.0 -O /opt/mupen64plus/libmupen64plus.so.2.0.0 -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/n64.sh -O /usr/local/bin/n64.sh -a "$LOG_FILE"
	sudo chown -v odroid:odroid /opt/mupen64plus/InputAutoCfg.ini | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /opt/mupen64plus/mupen64plus-input-sdl.so | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/mupen64plus/mupen64plus.cfg | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /opt/mupen64plus/libmupen64plus.so.2.0.0 | tee -a "$LOG_FILE"	
	sudo chmod -v 777 /usr/local/bin/n64.sh | tee -a "$LOG_FILE"
	sudo chmod -v 755 /opt/mupen64plus/mupen64plus-input-sdl.so | tee -a "$LOG_FILE"
	msgbox "Added support for standalone N64 emulator.  You'll need to restart Emulationstation in order for this update to take effect."
	touch "/home/odroid/.config/testupdate10252020"
	printf "\033c" >> /dev/tty1
fi

if [ ! -f "$UPDATE_DONE" ]; then
	printf "\nAdd support for pausing in standalone mupen64plus emulator and add Odyssey2 emulator support.  \n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mupen64plus-standalone/libmupen64plus.so.2.0.0 -O /opt/mupen64plus/libmupen64plus.so.2.0.0 -a "$LOG_FILE"
	sudo wget http://eple.us/retroroller/libretro/aarch64/o2em_libretro.so.zip -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/o2em/addo2em.txt -a "$LOG_FILE"
	sudo unzip -n o2em_libretro.so.zip -d /home/odroid/.config/retroarch/cores/ | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /opt/mupen64plus/libmupen64plus.so.2.0.0 | tee -a "$LOG_FILE"	
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/o2em_libretro.so | tee -a "$LOG_FILE"
	sudo mkdir -v /roms/odyssey2 | tee -a "$LOG_FILE"
	sudo sed -i '/wonderswancolor<\/theme>/r addo2em.txt' /etc/emulationstation/es_systems.cfg
	sudo sed -i '/Joy Mapping Pause/c\Joy Mapping Pause \= \"J0B10\/B1\"' /home/odroid/.config/mupen64plus/mupen64plus.cfg
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/mupen64plus/mupen64plus.cfg | tee -a "$LOG_FILE"
	sudo rm -v o2em_libretro.so.zip | tee -a "$LOG_FILE" | tee -a "$LOG_FILE"
	sudo rm -v addo2em.txt | tee -a "$LOG_FILE" | tee -a "$LOG_FILE"
	msgbox "Added support for pausing in standalone mupen64plus emulator using Select and A button combination and add Odyssey2 emulator support."
	touch "$UPDATE_DONE"
	rm -v -- "$0" | tee -a "$LOG_FILE"
	printf "\033c" >> /dev/tty1
	echo $c_brightness > /sys/devices/platform/backlight/backlight/backlight/brightness
	exit 187
fi