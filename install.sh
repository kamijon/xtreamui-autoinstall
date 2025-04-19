#!/bin/bash

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

echo "==============================="
echo "  Xtream UI Auto Installer     "
echo "==============================="

echo "[1/7] Updating system..."
apt update && apt upgrade -y

echo "[2/7] Installing required packages..."
apt install -y sudo curl wget unzip zip net-tools cron nginx \
  php php-cli php-mysql php-curl php-mbstring php-xml php-bcmath \
  software-properties-common ffmpeg mysql-server

echo "[3/7] Securing MySQL installation..."
mysql_secure_installation <<EOF

y
iptvadmin
iptvadmin
y
y
y
y
EOF

echo "[4/7] Creating installation directory..."
mkdir -p /opt/xtreamui
cd /opt/xtreamui

echo "[5/7] Downloading Xtream UI installer..."
wget -O xtreamui-install.zip https://github.com/hikbselmi/xtreamui_autoinstall/archive/refs/heads/master.zip

echo "[6/7] Extracting files..."
unzip xtreamui-install.zip
cd xtreamui_autoinstall-master

echo "[7/7] Running Xtream UI installer..."
bash install.sh

echo "✅ Xtream UI installation finished!"
echo "➡ You can now access your panel at:"
echo "   http://your-server-ip:25500"
