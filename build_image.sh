#!/bin/bash

# This script will download, configure and build an LEDE image using it's Image Builder

# Written by Vasiliy Solovey, 2016

# Image Builder settings
PROFILE="tl-wr842n-v1"
PACKAGES="kmod-sched-cake luci-ssl-openssl luci-app-upnp luci-app-sqm"
FILES="gen_files/"

chmod +x gen_configs.sh
./gen_configs.sh

# Script vars
IMAGEBUILDER_URI="https://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-imagebuilder-ar71xx-generic.Linux-x86_64.tar.xz"
BUILD_DEPS="build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget"

rm -r /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

# Download Image Builder
wget -O /tmp/image-builder.tar.xz $IMAGEBUILDER_URI

# Extract the archive
tar -xf /tmp/image-builder.tar.xz -C /tmp/

cp -r $FILES /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

cd /tmp/lede-imagebuilder-ar71xx-generic.Linux-x86_64

# Preparation
sudo apt-get install $BUILD_DEPS -y

# Make image
make image PROFILE=$PROFILE PACKAGES=$PACKAGES FILES=$FILES
