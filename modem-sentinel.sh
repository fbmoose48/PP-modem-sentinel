#!/bin/bash

sleep 30s #Gives modem time to boot after startup
modem=/dev/ttyUSB2 #Defines a variable representing the modem's USB connection

while : #Infinite loop
do
if test -c "$modem"; then #If the modem is accessible
  sleep 15s
  else #If the modem is inaccessible
  echo "Modem disconnected at" $(date -u) >> /home/alarm/Scripts/ModemSentinel.log #Prints GMT timestamped message to the logfile
  systemctl stop eg25-manager
  sleep 15s #Instantly restarting eg25-manager doesn't always work
  systemctl start eg25-manager
  sleep 40s #Modem takes a while to wake up
  if test ! -c "$modem"; then #If the modem is still not visible
    echo "Modem reconnection failed; rebooting system." >> /home/alarm/Scripts/ModemSentinel.log #Record failure to the logfile
    shutdown -r now #Reboot. If you're using Megi's multiboot image, reboots will get stuck at the boot menu. To avoid this, go to the boot menu, select your primary OS, and hold down the power button. This will make it so you boot directly to your primary OS, but the boot menu can still be accessed by holding volume down while turning the Pinephone on.
    else
    echo "Modem reconnected successfully." >> /home/alarm/Scripts/ModemSentinel.log #Record success to the logfile
  fi
fi
done
