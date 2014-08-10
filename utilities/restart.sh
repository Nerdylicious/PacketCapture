#!/bin/bash
#Programmer: Irish Medina
#Last Modified: June 14, 2013
#Purpose: Restarts a card to managed mode

echo -e -n "\nPlease enter an interface to restart (ie. wlan1): "
read INTERFACE

if [[ ! "$INTERFACE" =~ ^[(a-z)|(0-9)]+$ ]]; then
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

for((i=0; i<5; i++))
do
	sudo airmon-ng stop mon$i
done

sudo ifconfig "$INTERFACE" down
sudo iwconfig "$INTERFACE" mode managed
sudo ifconfig "$INTERFACE" up
sudo service network-manager start

