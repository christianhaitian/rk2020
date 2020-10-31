#!/bin/bash
sudo umount /roms
sudo ln -s /dev/mmcblk0 /dev/hda
sudo ln -s /dev/mmcblk0p3 /dev/hda3
[ ! -f /boot/doneit ] && { sudo echo ", +" | sudo sfdisk -N 3 --force /dev/mmcblk0; sudo touch "/boot/doneit"; msgbox "EASYROMS partition expansion and conversion to exfat in process.  Please be patient as the system will reboot 2 to 3 times to complete this.  Hit A to continue."; reboot; }
sudo fdisk -l --bytes /dev/hda >> /boot/test.txt
sudo awk '{print $5}' /boot/test.txt >> /boot/test2.txt
maxsize=$(tail -n 1 /boot/test2.txt)
sudo ntfsfix -d /dev/hda3
sudo ntfsresize -f -s $maxsize /dev/hda3
sudo ntfsfix -d /dev/hda3
sudo mkfs.exfat -n EASYROMS /dev/hda3
sudo fsck.exfat -a /dev/hda3
sudo mount -t exfat /dev/mmcblk0p3 /roms
sudo tar -xvf /boot/roms.tar -C /
sudo umount /roms
sudo cp /boot/fstab.exfat /etc/fstab
sync
sudo rm -f /boot/test*
sudo rm -f /boot/doneit
sudo rm -f /boot/roms.tar
sudo rm -f /boot/fstab.exfat
exitcode=$?
if [ $exitcode -eq 0 ]; then msgbox "Completed expansion of EASYROMS partition and conversion to exfat. System will reboot and load Emulationstation now after you hit the A button."
systemctl disable firstboot.service
reboot
else
msgbox "EASYROMS partition expansion and conversion to exfat failed for an unknown reason.  Please expand the partition using an alternative tool such as Minitool Partition Wizard.  System will reboot and load Emulationstation now after you hit the A button."
systemctl disable firstboot.service
reboot
fi
