#!/bin/sh

# This script will download, configure and build an LEDE image using it's Image Builder

# Written by Vasiliy Solovey, 2016

# TODO list:
#   1. Add variables.

cd /tmp/
rm -r image-builder/

# Download Image Builder
wget -O image-builder.tar.bz2 https://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-imagebuilder-ar71xx-generic.Linux-x86_64.tar.bz2

mkdir image-builder

# Extract the archive
tar -xf image-builder.tar.bz2

cd ./lede-imagebuilder-ar71xx-generic.Linux-x86_64

# Preparation
sudo apt-get install build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget -y

# Ask for a root password
read -p "Enter your router's root pasword: " CLEAR_PASS

# Generate root password hash
RAND_STRING="$(openssl rand -hex 5)"
HASH="$(openssl passwd -1 -salt $RAND_STRING $CLEAR_PASS)"

# Write hash to file
sed -i -- "s/root::0:0:99999:7:::/root:$(echo $HASH | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g'):17082:0:99999:7:::/g" "files/etc/shadow"

# Ask for a Wi-Fi password
read -p "Enter your own Wi-Fi password: " WIFI_PASS

# Write Wi-Fi password to file
sed -i -- "s/OWN_WIFI_PASS_PLACEHOLDER/$WIFI_PASS/g" "files/etc/config/wireless"

# Ask for a DDNS settings
read -p "DDNS host: " DDNS_HOST
read -p "DNS-O-Matic username: " DNSOMATIC_USER
read -p "DNS-O-Matic password: " DNSOMATIC_PASS

# Write DDNS settings
sed -i -- "s/DDNS_HOST_PLACEHOLDER/$DDNS_HOST/g" "files/etc/config/ddns"
sed -i -- "s/DNSOMATIC_USER_PLACEHOLDER/$DNSOMATIC_USER/g" "files/etc/config/ddns"
sed -i -- "s/DNSOMATIC_PASS_PLACEHOLDER/$DNSOMATIC_PASS/g" "files/etc/config/ddns"

# Make image
make image PROFILE=tl-wr842n-v1 PACKAGES="luci-ssl-openssl luci-app-ddns luci-app-upnp nano wget ca-certificates" FILES=files/
