#!/bin/bash
#sudo systemctl enable smbd.service
sudo timedatectl set-ntp 1
sudo systemctl start smbd
sudo systemctl start nmbd
#sudo systemctl enable nmbd
#sudo systemctl enable ssh
sudo systemctl start ssh.service