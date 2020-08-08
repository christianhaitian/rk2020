#!/bin/bash

testcpu=$(cat /proc/cpuinfo | sed '37!d')
pretestmem=$(free -m)
testmem=$(echo $pretestmem | cut -c 45-52)

msgbox "$testcpu      $testmem"

if [[ $testcpu == *"Rockchip rk3326"* ]] && [[ $testmem == *"894"* ]]; then
   msgbox "Looks like this is a genuine RK2020."
else
   msgbox "This doesn't seem to be a genuine RK2020."
fi
