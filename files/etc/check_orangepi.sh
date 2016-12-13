#!/bin/sh

RESPONSE="$(wget -T 3 -O - http://orangepione.lan:8000/stat)"
STRING="Connected clients"

restart() {
       echo 0 > /sys/class/gpio/gpio6/value
       sleep 1
       echo "Restarting..."
       echo 1 > /sys/class/gpio/gpio6/value
}

case "$RESPONSE" in
*$STRING*) echo "Orange Pi is alive!" ;;
*        ) echo "Not alive, restarting!" && restart ;;
esac

