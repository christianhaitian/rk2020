#!/bin/bash

if  [[ $1 == "standalone" ]]; then
/opt/mupen64plus/mupen64plus --resolution 320x240 --plugindir /opt/mupen64plus --gfx mupen64plus-video-rice.so --corelib /opt/mupen64plus/libmupen64plus.so.2 --datadir /opt/mupen64plus "$2"
else
/usr/local/bin/"$1" -L /home/odroid/.config/"$1"/cores/"$2"_libretro.so "$3"
fi
