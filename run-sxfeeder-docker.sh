#!/bin/bash

# Eliminar contenedor previo si existe
docker rm -f sxfeeder 2>/dev/null

# Leer el serial real del host (para pasárselo al contenedor como variable)
SERIAL=$(cat /sys/firmware/devicetree/base/serial-number 2>/dev/null | tr -d '\0')
echo "[launcher] Serial de esta Orange Pi: $SERIAL"

# Ejecutar contenedor con:
# - Tu config del host montada
# - Serial del host pasado como variable de entorno
# - Truco del cpuinfo falso hecho inline
exec docker run \
    --name sxfeeder \
    --rm \
    --privileged \
    --network host \
    -e SERIAL="$SERIAL" \
    -v /etc/sxfeeder.ini:/etc/sxfeeder.ini:ro \
    -v /var/run/sxfeeder:/var/run/sxfeeder \
    -v /var/log/sxfeeder.log:/var/log/sxfeeder.log \
    sxfeeder-custom \
    /bin/bash -c '
        cp /proc/cpuinfo /tmp/cpuinfo_fake
        echo "Hardware    : BCM2835" >> /tmp/cpuinfo_fake
        echo "Revision    : c03111" >> /tmp/cpuinfo_fake
        echo "Serial      : $SERIAL" >> /tmp/cpuinfo_fake
        echo "Model       : Raspberry Pi 4 Model B Rev 1.1" >> /tmp/cpuinfo_fake
        mount --make-private /proc
        mount --bind /tmp/cpuinfo_fake /proc/cpuinfo
        mkdir -p /var/run/sxfeeder
        exec /usr/bin/sxfeeder
    '
