#!/bin/bash
clear

UPDATE_DATE="10222020"
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

if [ ! -f "$UPDATE_DONE" ]; then
	printf "\nAdd option to use Mednafen_PCE or Mednafen_supergrafx retroarch core for increased accuracy and compatibility\n" | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mednafen_pce/mednafen_pce_libretro.so -O /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so -a "$LOG_FILE"
	sudo chmod -v 777 /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so | tee -a "$LOG_FILE"
	sudo chown -v odroid:odroid /home/odroid/.config/retroarch/cores/mednafen_pce_libretro.so | tee -a "$LOG_FILE"
	sudo mv -v /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update$UPDATE_DATE.bak | tee -a "$LOG_FILE"
	sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update3.1/mednafen_pce/es_systems.cfg -O /etc/emulationstation/es_systems.cfg -a "$LOG_FILE"
	sudo chown -v odroid:odroid /etc/emulationstation/es_systems.cfg | tee -a "$LOG_FILE"
	msgbox "You now have the option to select Mednafen_PCE retroarch core for PCE/TG-16 games.  Restart EmulationStation in order enable this new feature."
	touch "$UPDATE_DONE"
	rm -v -- "$0" | tee -a "$LOG_FILE"
	printf "\033c" >> /dev/tty1
	exit 187
fi