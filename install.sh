#!/bin/bash

# XTREAM UI AUTO INSTALL SCRIPT - For Ubuntu 22.04
# Author: kamijon
# Last Updated: 2025-04

# -------------------------------
# Step 0: Check for root access
# -------------------------------
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root."
  exit 1
fi

# -------------------------------
# Step 1: Update and upgrade system
# -------------------------------
echo "🔄 Updating system..."
apt update && apt upgrade -y

# -------------------------------
# Step 2: Install dependencies
# -------------------------------
echo "📦 Installing required packages..."
apt install -y sudo curl wget unzip zip net-tools cron ufw nginx \
  php php-cli php-mysql php-curl php-mbstring php-xml php-bcmath \
  software-properties-common ffmpeg mysql-server

# -------------------------------
# Step 3: Configure firewall
# -------------------------------
echo "🛡️  Configuring UFW firewall..."
ufw allow OpenSSH
ufw allow 25461/tcp
ufw allow 25500/tcp
ufw allow 8000:8100/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# -------------------------------
# Step 4: Secure MySQL
# -------------------------------
echo "🔐 Securing MySQL..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xtreampass'; FLUSH PRIVILEGES;"

# Create database and user for Xtream UI
mysql -uroot -pxtreampass -e "CREATE DATABASE xtreamui;"
mysql -uroot -pxtreampass -e "CREATE USER 'xtream'@'localhost' IDENTIFIED BY 'xtreampass';"
mysql -uroot -pxtreampass -e "GRANT ALL PRIVILEGES ON xtreamui.* TO 'xtream'@'localhost';"
mysql -uroot -pxtreampass -e "FLUSH PRIVILEGES;"

# -------------------------------
# Step 5: Download Xtream UI
# -------------------------------
echo "📥 Downloading Xtream UI installer..."
mkdir -p /opt/xtreamui && cd /opt/xtreamui
wget -O xtreamui.zip https://github.com/hikbselmi/xtreamui_autoinstall/archive/refs/heads/master.zip

echo "📂 Extracting..."
unzip xtreamui.zip
cd xtreamui_autoinstall-master

# -------------------------------
# Step 6: Run Xtream UI installer
# -------------------------------
echo "🚀 Running Xtream UI installer..."
bash install.sh

# -------------------------------
# Step 7: Finish
# -------------------------------
clear
echo "✅ Xtream UI installation completed successfully!"
echo "🌐 Visit your panel at: http://your-server-ip:25500"
echo "🔑 MySQL root password: xtreampass"
echo "🔑 Xtream UI DB: xtreamui | User: xtream | Pass: xtreampass"
echo "🔥 Firewall configured and active (UFW)"
