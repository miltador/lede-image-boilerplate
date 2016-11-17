#!/bin/bash

# Written by Vasiliy Solovey, 2016

GEN_FILES="gen_files/"

cp -r "files/" "gen_files/"

# Ask for a root password
read -s -p "Enter your router's root pasword: " CLEAR_PASS

echo ""

# Ask for a Wi-Fi password
read -s -p "Enter your own Wi-Fi password: " WIFI_PASS

echo ""

# Generate root password hash
RAND_STRING="$(openssl rand -hex 5)"
HASH="$(openssl passwd -1 -salt $RAND_STRING $CLEAR_PASS)"

# Write hash to file
sed -i -- "s/root::0:0:99999:7:::/root:$(echo $HASH | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g'):17082:0:99999:7:::/g" "$GEN_FILES/etc/shadow"

# Write Wi-Fi password to file
sed -i -- "s/OWN_WIFI_PASS_PLACEHOLDER/$WIFI_PASS/g" "$GEN_FILES/etc/config/wireless"