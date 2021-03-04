#!/bin/bash

# This script installs ARTiC2
# Run as root
# Usage: sudo ./install.sh

check_root() {
	if [[ $(id -u) != "0" ]]
	then
		printf "Run this file as root\n"
		exit 0
	fi
}
check_internet() {
    wget -q --tries=10 --timeout=10 --spider https://github.com
    if [[ $? -eq 0 ]]; then
    	echo "Connection Found"
    else
    	printf "NO Connection Found\nExiting...\n"
	exit 0
    fi
}

debian_install() {
	check_root
	check_internet
    sudo add-apt-repository ppa:deadsnakes/ppa -y > /dev/null 2>&1
    sudo apt-get install git python3.7 python3-pip wget unzip lsof -y
    git clone https://github.com/blackbotinc/Atomic-Red-Team-Intelligence-C2.git
    cd artic2
    python3.7 -m pip install -r requirements.txt
    sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip -O /usr/local/sbin/ngrok
    sudo unzip /usr/local/sbin/ngrok
    sudo chmod a+x /usr/local/sbin/ngrok
}

arch_install() {
	check_root
	check_internet
    echo "y" | sudo pacman -S git python-pip python3 wget unzip lsof
    check_internet
    git clone https://github.com/blackbotinc/Atomic-Red-Team-Intelligence-C2.git
    cd artic2
    pip3 install -r requirements.txt
    sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip -O /usr/local/sbin/ngrok
    sudo unzip /usr/local/sbin/ngrok
    sudo chmod a+x /usr/local/sbin/ngrok
}



if [[ $1 ]]
then
	if [[ $(which apt-get) == "/usr/bin/apt-get" ]]
	then
    	debian_install
	elif [[ $(which pacman) == "/usr/bin/pacman" ]]
	then
    	arch_install
	fi
else
	printf "Invaild argument\nAvailable arguments: install\n"
fi
