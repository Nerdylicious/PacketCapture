#!/bin/bash
#Programmer: Irish Medina
#Last Modified: June 8, 2013
#Purpose: Captures packets for a particular access point

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

echo -e -n "\nDo you want to airodump? [y/n]: "
read IS_AIRODUMP

if [[ "$IS_AIRODUMP" =~ [y|n] ]]; then
	if [[ "$IS_AIRODUMP" =~ [y] ]]; then
		#see all connections
		gnome-terminal -x sudo airodump-ng "$INTERFACE" --channel "$CH"
	fi
else
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

echo -n "Please enter AP MAC address: "
read AP_MAC

if [[ ! "$AP_MAC" =~ ^[0-9a-zA-Z]{2}:[0-9a-zA-Z]{2}:[0-9a-zA-Z]{2}:[0-9a-zA-Z]{2}:[0-9a-zA-Z]{2}:[0-9a-zA-Z]{2}$ ]]; then
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

echo -n "Please enter a name for capture file: "
read FILE_NAME

if [[ ! "$FILE_NAME" =~ ^[(a-zA-Z)|(0-9)]+$ ]]; then
	echo "Error: Input is invalid"
	echo "Exiting ..."
	exit 1
fi

#do airodump for that particular access point and save capture in a file
echo -e -n "Capturing packets for $AP_MAC ...\n"
gnome-terminal -x sudo airodump-ng -c "$CH" --bssid "$AP_MAC" -w "$FILE_NAME" "$INTERFACE"



