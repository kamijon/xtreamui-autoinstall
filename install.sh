#!/bin/bash

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

echo "Updating system packages..."
apt update && apt upgrade -y

echo "Installing required dependencies..."
apt install -y sudo curl wget unzip zip net-tools cron nginx php php-cli php-mysql php-curl php-mbstring php-xml php-bcmath ffmpeg

echo "Creating Xtream UI installation directory..."
mkdir -p /opt/xtreamui
cd /opt/xtreamui

echo "Downloading Xtream UI auto installer..."
wget -O xtreamui-install.zip https://github.com/hikbselmi/xtreamui_autoinstall/archive/refs/heads/master.zip

echo "Unzipping installer..."
unzip xtreamui-install.zip
cd xtreamui_autoinstall-master

echo "Starting Xtream UI installation..."
bash install.sh

echo "Installation complete!"
echo "Access your Xtream UI panel via:"
echo "  http://your-server-ip:25500"
