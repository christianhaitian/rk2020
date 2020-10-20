#!/bin/bash

if  [[ $1 == "standalone" ]]; then
/opt/ppsspp/PPSSPPSDL "$2"
else
/usr/local/bin/retroarch -L /home/odroid/.config/retroarch/cores/ppsspp_libretro.so "$2"
fi
