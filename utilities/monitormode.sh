#!/bin/bash
#Programmer: Irish Medina
#Last Modified: June 14, 2013
#Purpose: Changes a card to monitor mode

echo -e "\nWelcome!\n"

echo -n "Do you want to iwconfig? [y/n]: "
read IS_IW

if [[ "$IS_IW" =~ [y|n] ]]; then
	if [[ "$IS_IW" =~ [y] ]]; then
		iwconfig
	fi
else
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

echo -n "Please enter an interface (ie. wlan1): "
read INTERFACE

if [[ ! "$INTERFACE" =~ ^[(a-z)|(0-9)]+$ ]]; then
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

echo -n "Please enter a channel (ie. 1 to 13): "
read CH

if [[ "$CH" =~ ^[0-9]+$ ]]; then
	if [[ "$CH" -gt 0 && "$CH" -lt 14 ]]; then
		#do nothing
		echo ""
	else
		echo "Error: Input is invalid"
		echo "Exiting ..."
		exit 1
	fi
fi

#order of commands must remain intact
sudo iwconfig "$INTERFACE" channel $CH

echo -n "Stop network-manager? [y/n]: "
read IS_NETWORK_MANAGER

if [[ "$IS_NETWORK_MANAGER" =~ [y|n] ]]; then
	if [[ "$IS_NETWORK_MANAGER" =~ [y] ]]; then
		sudo service network-manager stop
	fi
else
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

sudo ifconfig "$INTERFACE" down
sudo iwconfig "$INTERFACE" mode monitor
sudo ifconfig "$INTERFACE" up

#to start the interface in monitor mode
sudo airmon-ng start "$INTERFACE" "$CH"

sudo airmon-ng stop mon0

echo -n "Press q to return to managed mode and quit: "
read IS_QUIT

if [[ "$IS_QUIT" =~ [q] ]]; then
	sudo ifconfig "$INTERFACE" down
	sudo iwconfig "$INTERFACE" mode managed
	sudo ifconfig "$INTERFACE" up
	sudo service network-manager start
else
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

