#!/bin/bash

# This script will download, configure and build an LEDE image using it's Image Builder

# Written by Vasiliy Solovey, 2016

# TODO list:
#   1. Add variables.

# Ask for a root password
read -s -p "Enter your router's root pasword: " CLEAR_PASS

echo ""

# Ask for a Wi-Fi password
read -s -p "Enter your own Wi-Fi password: " WIFI_PASS

rm -r /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

# Download Image Builder
wget -O /tmp/image-builder.tar.xz https://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-imagebuilder-ar71xx-generic.Linux-x86_64.tar.xz

# Extract the archive
tar -xf /tmp/image-builder.tar.xz -C /tmp/

cp -r files/ /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

cd /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

# Preparation
sudo apt-get install build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget -y

# Generate root password hash
RAND_STRING="$(openssl rand -hex 5)"
HASH="$(openssl passwd -1 -salt $RAND_STRING $CLEAR_PASS)"

# Write hash to file
sed -i -- "s/root::0:0:99999:7:::/root:$(echo $HASH | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g'):17082:0:99999:7:::/g" "files/etc/shadow"

# Write Wi-Fi password to file
sed -i -- "s/OWN_WIFI_PASS_PLACEHOLDER/$WIFI_PASS/g" "files/etc/config/wireless"

# Make image
make image PROFILE=tl-wr842n-v1 PACKAGES="luci-ssl-openssl luci-app-upnp" FILES=files/
