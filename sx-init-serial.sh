#!/bin/bash

set -e

echo "[+] Detectando serial real del hardware..."

SERIAL=$(awk '/sunxi_serial/ {print $3}' /sys/class/sunxi_info/sys_info)

if [ -z "$SERIAL" ]; then
    echo "ERROR: no se pudo leer serial sunxi"
    exit 1
fi

echo "[+] Serial detectado: $SERIAL"

echo "$SERIAL" > /etc/sxfeeder.serial

echo "[+] Serial guardado en /etc/sxfeeder.serial"
