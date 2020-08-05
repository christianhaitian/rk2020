#!/bin/bash
clear

LOG_FILE="/home/odroid/update1.log"

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
  exit 1
fi

printf "\nFirst, let's upgrade the installed packages in this distro to the latest...\n" | tee -a "$LOG_FILE"
sudo apt update -y | tee -a "$LOG_FILE"
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y | tee -a "$LOG_FILE"
printf "\nNow that that's done, let's move on with the rest of the updates...\n" | tee -a "$LOG_FILE"

LOGODIR="/boot/BMPs/"

if [ -d "$LOGODIR" ]; then
  printf "\nDownloading and copying logos to /boot/BMPs folder if they don't exist already...\n" | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo1.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo2.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo3.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
else
  printf "\nCreating logo directory in boot folder...\n" | tee -a "$LOG_FILE"
  sudo mkdir /boot/BMPs | tee -a "$LOG_FILE"
  printf "\nDownloading and copying logos to /boot/BMPs folder...\n" | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo1.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo2.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/BMPs/logo3.bmp -P /boot/BMPs/ | tee -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/imageshift.sh -P /home/odroid/.config  | tee -a "$LOG_FILE"
fi

IMAGESHIFTEXIST=$(sudo crontab -l | sed -n '/imageshift.sh/p')

if [[ "$IMAGESHIFTEXIST" == *"imageshift.sh"* ]]; then
  printf "\nimageshift script already exists, moving on...\n" | tee -a "$LOG_FILE"
else
  printf "\nDownloading and copying imageshift script to proper location and setting cron job at each boot...\n" | tee -a "$LOG_FILE"
  sudo wget -nc https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/imageshift.sh -P /home/odroid/.config/  | tee -a "$LOG_FILE"
  sudo chmod 777 /home/odroid/.config/imageshift.sh | tee -a "$LOG_FILE"
  sudo crontab -l | sed '$ a\@reboot /home/odroid/.config/imageshift.sh' | sudo crontab -  | tee -a "$LOG_FILE"
  sudo service cron reload | tee -a "$LOG_FILE"
fi

printf "\nDownloading and copying es-theme-freeplay theme to the emulationstation themes folder...\n"  | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/es-theme-freeplay.tar | tee -a "$LOG_FILE"
sudo tar -xf es-theme-freeplay.tar -C /etc/emulationstation/themes/ | tee -a "$LOG_FILE"
sudo rm es-theme-freeplay.tar | tee -a "$LOG_FILE"

printf "\nChange Atomiswave from retrorun to using the retroarch 64 bit flycast libretro emulator core instead...\n" | tee -a "$LOG_FILE"
suco cp /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update1.bak
sudo sed -i 's+retrorun32 -s ~ -d /opt/libretro/flycast /opt/libretro/flycast/flycast_libretro.so+/usr/local/bin/retroarch -L /home/odroid/.config/retroarch/cores/flycast_libretro.so+g' /etc/emulationstation/es_systems.cfg

printf "\nDownloading and copying updated PPSSPPSDL...\n" | tee -a "$LOG_FILE"
sudo mv /opt/ppsspp/PPSSPPSDL /opt/ppsspp/PPSSPPSDL.update1.bak
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ppsspp/PPSSPPSDL -P /opt/ppsspp/ | tee -a "$LOG_FILE"
sudo chmod 777 /opt/ppsspp/PPSSPPSDL

printf "\nDownloading and copying updated emulationstation....\n" | tee -a "$LOG_FILE"
sudo service emulationstation stop
sudo mv /usr/bin/emulationstation/emulationstation /usr/bin/emulationstation/emulationstation.update1.bak
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/emulationstation/emulationstation -P /usr/bin/emulationstation/ | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/emulationstation/system.png -O /etc/emulationstation/themes/"Retro Arena Redux"/retropie/system.png | tee -a "$LOG_FILE"
sudo chmod 777 /usr/bin/emulationstation/emulationstation
sudo service emulationstation start

printf "\nDownloading and copying updated retroarch 1.8.9 executables...\n"
sudo mv /opt/retroarch/bin/retroarch /opt/retroarch/bin/retroarch.update1.bak
sudo mv /opt/retroarch/bin/retroarch32 /opt/retroarch/bin/retroarch32.update1.bak
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/retroarch/retroarch -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"
wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/retroarch/retroarch32 -P /opt/retroarch/bin/ | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ra_save_dir.txt -P /home/odroid/ | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ra_savestate_dir.txt -P /home/odroid/ | tee -a "$LOG_FILE"
sudo sed -e '/savefiles_in_content_dir/{r /home/odroid/ra_save_dir.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
sudo sed -e '/savefiles_in_content_dir/{r /home/odroid/ra_save_dir.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
sudo mv /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg
sudo mv /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg
sudo rm /home/odroid/ra_save_dir.txt
sudo sed -e '/savestates_in_content_dir/{r /home/odroid/ra_savestate_dir.txt' -e 'd}' /home/odroid/.config/retroarch/retroarch.cfg > /home/odroid/retroarch64.cfg
sudo sed -e '/savestates_in_content_dir/{r /home/odroid/ra_savestate_dir.txt' -e 'd}' /home/odroid/.config/retroarch32/retroarch.cfg > /home/odroid/retroarch32.cfg
sudo mv /home/odroid/retroarch64.cfg /home/odroid/.config/retroarch/retroarch.cfg
sudo mv /home/odroid/retroarch32.cfg /home/odroid/.config/retroarch32/retroarch.cfg
sudo rm /home/odroid/ra_savestate_dir.txt
sudo apt -y install libqt5gui5 libv4l-dev | tee -a "$LOG_FILE"
sudo chmod 777 /opt/retroarch/bin/retroarch
sudo chmod 777 /opt/retroarch/bin/retroarch32

if [ -d "/roms/quake" ]; then
  printf "\nMoving Quake and Pico-8 into /roms/ports folder and ports menu for consolidation purposes...\n" | tee -a "$LOG_FILE"
  sudo cp /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.update1.bak
  sudo sed -i '/Pico8/,+8d' /etc/emulationstation/es_systems.cfg
  sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/es_ports_entry.txt -O /home/odroid/es_ports_entry.txt | tee -a "$LOG_FILE"
  sudo sed -e '/Quake/,+5d' -e '/quake/{r /home/odroid/es_ports_entry.txt' -e 'd}' /etc/emulationstation/es_systems.cfg > /home/odroid/es_systems_temp.cfg
  sudo mv -f /home/odroid/es_systems_temp.cfg /etc/emulationstation/es_systems.cfg
  sudo rm /home/odroid/es_ports_entry.txt
  sudo mkdir /roms/ports
  sudo mkdir /roms/ports/pico-8
  sudo mv -f /roms/quake /roms/ports/quake
  sudo mkdir /roms/ports/quake/quakepaks
  sudo mv -f /roms/ports/quake/*.pak /roms/quake/quakepaks
  sudo touch /roms/ports/quake/quakepaks/"PUT YOUR PAK FILES HERE"
  sudo mv -f /roms/pico-8/* /roms/ports/pico-8/
  sudo touch /roms/ports/pico-8/"PUT YOUR PICO-8 PNG FILES HERE"
  sudo rm -rf /roms/pico-8
  sudo rm /roms/ports/pico-8/Pico-8.sh
  sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ports/Pico-8.sh -P /roms/ports/ | tee -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ports/Quake.sh -P /roms/ports/ | tee -a "$LOG_FILE"
  sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/ports/opt/pico-8.sh -O /opt/pico-8/pico-8.sh | tee -a "$LOG_FILE"
  sudo chmod 777 /opt/pico-8/pico-8.sh
fi

printf "\nSecure samba with odroid login credentials and update remote services scripts...\n" | tee -a "$LOG_FILE"
echo -e "odroid\nodroid" | sudo smbpasswd -s -a odroid  | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/samba/smb.conf -O /etc/samba/smb.conf | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/system/Disable%20Remote%20Services.sh -O /opt/system/"Disable Remote Services.sh" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/system/Enable%20Remote%20Services.sh -O /opt/system/"Enable Remote Services.sh" | tee -a "$LOG_FILE"
sudo chmod 777 /opt/system/"Enable Remote Services.sh"
sudo chmod 777 /opt/system/"Disable Remote Services.sh"

printf "\nUpdate emulationstation config to default screen timeout to black...\n" | tee -a "$LOG_FILE"
sudo wget https://github.com/christianhaitian/rk2020/raw/master/ForThera/Update1/es_setting_change.txt -O /home/odroid/es_setting_change.txt | tee -a "$LOG_FILE"
sudo sed -e '/ScreenSaverBehavior/{r /home/odroid/es_setting_change.txt' -e 'd}' /home/odroid/.emulationstation/es_settings.cfg > /home/odroid/newes_settings.cfg
sudo mv -f /home/odroid/newes_settings.cfg /home/odroid/.emulationstation/es_settings.cfg
sudo rm /home/odroid/es_setting_change.txt

printf "\nLast but not least, let's ensure that Drastic performance has not been negatively impacted by these updates...\n" | tee -a "$LOG_FILE"
sudo ln -sf /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0.10.0 /usr/lib/arm-linux-gnueabihf/libSDL2-2.0.so.0

printf "\nAll Done!\n\n\e[39m"  | tee -a "$LOG_FILE"
rm -- "$0"
exit 0
done