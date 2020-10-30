#!/bin/bash
sudo umount /roms
sudo ln -s /dev/mmcblk0 /dev/hda
sudo ln -s /dev/mmcblk0p3 /dev/hda3
[ ! -f /boot/doneit ] && { sudo echo ", +" | sudo sfdisk -N 3 --force /dev/mmcblk0; sudo touch "/boot/doneit"; msgbox "NTFS partition expansion in process.  Please be patient as the system will reboot 2 to 3 times to complete this.  Hit A to continue."; reboot; }
sudo fdisk -l --bytes /dev/hda >> /boot/test.txt
sudo awk '{print $5}' /boot/test.txt >> /boot/test2.txt
maxsize=$(tail -n 1 /boot/test2.txt)
sudo ntfsfix -d /dev/hda3
sudo ntfsresize -f -s $maxsize /dev/hda3
sudo ntfsfix -d /dev/hda3
echo -ne '\xeb\x58\x90' | sudo dd conv=notrunc bs=1 count=3 of=/dev/hda3
sync
sudo rm -f /boot/test*
sudo rm -f /boot/doneit
exitcode=$?
if [ $exitcode -eq 0 ]; then msgbox "Completed expansion of ntfs partition. System will reboot and load Emulationstation now after you hit the A button."
systemctl disable firstboot.service
reboot
else
msgbox "NTFS partition expansion failed for an unknown reason.  Please expand the partition using an alternative tool such as Minitool Partition Wizard.  System will reboot and load Emulationstation now after you hit the A button."
systemctl disable firstboot.service
reboot
fi
