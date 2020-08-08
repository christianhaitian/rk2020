#!/bin/bash
sudo umount /dev/mmcblk0p3
sudo ntfsfix -d /dev/mmcblk0p3
sudo mount -t ntfs-3g /dev/mmcblk0p3 /roms
