#!/bin/bash
sudo wget https://github.com/christianhaitian/rk2020/master/ForThera/Update3.1/BootFileUpdates.tar.gz
sudo wget https://github.com/christianhaitian/rk2020/master/ForThera/Update3.1/KernelUpdate.tar.gz
sudo tar --same-owner -zxvf BootFileUpdates.tar.gz -C /
sudo tar --same-owner -zxvf KernelUpdate.tar.gz -C /
sudo rm -v BootFileUpdates.tar.gz
sudo rm -v KernelUpdate.tar.gz
rm -- "$0"
sudo reboot