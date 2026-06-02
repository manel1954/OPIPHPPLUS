#!/bin/bash
set -e

# 1. Obtener serial real de Orange Pi
SERIAL=$(cat /sys/firmware/devicetree/base/serial-number 2>/dev/null | tr -d '\0')

if [ -z "$SERIAL" ]; then
    MACHINE_ID=$(cat /etc/machine-id)
    SERIAL=$(echo -n "$MACHINE_ID" | tr -cd 'a-f0-9' | head -c 16)
    while [ ${#SERIAL} -lt 16 ]; do SERIAL="${SERIAL}0"; done
fi

echo "[launcher] Usando serial: $SERIAL"

# 2. Crear archivo temporal con cpuinfo + serial
FAKE_CPUINFO="/tmp/sxfeeder_fake_cpuinfo"
cp /proc/cpuinfo "$FAKE_CPUINFO"
echo "Serial          : $SERIAL" >> "$FAKE_CPUINFO"

# 3. Ejecutar con LD_PRELOAD para interceptar open()
export LD_PRELOAD=/home/pi/A108/fake_cpuinfo.so

REAL_BIN="/usr/bin/sxfeeder"
exec setpriv --reuid=sxfeeder --regid=sxfeeder --init-groups "$REAL_BIN"
