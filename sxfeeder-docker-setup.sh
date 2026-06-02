#!/bin/bash
set -e

echo "[1/5] Instalando Docker..."
apt update
apt install -y docker.io

systemctl enable docker
systemctl start docker

echo "[2/5] Detectando serial hardware..."

SERIAL=$(awk '/sunxi_serial/ {print $3}' /sys/class/sunxi_info/sys_info)

if [ -z "$SERIAL" ]; then
  echo "ERROR: no se pudo leer serial"
  exit 1
fi

echo "[OK] Serial: $SERIAL"

echo "[3/5] Creando cpuinfo compatible..."
mkdir -p /opt/sxfeeder
cp /proc/cpuinfo /opt/sxfeeder/cpuinfo

sed -i '/Serial/d' /opt/sxfeeder/cpuinfo
echo "Serial          : ${SERIAL:0:16}" >> /opt/sxfeeder/cpuinfo

echo "[4/5] Parando servicio antiguo..."
systemctl stop sxfeeder || true
systemctl disable sxfeeder || true

echo "[5/5] Lanzando SXFeeder en Docker..."

docker rm -f sxfeeder >/dev/null 2>&1 || true

docker run -d \
  --name sxfeeder \
  --restart unless-stopped \
  --network host \
  -v /etc/sxfeeder.ini:/etc/sxfeeder.ini:ro \
  -e SXFEEDER_SERIAL=$SERIAL \
  ghcr.io/sdr-enthusiasts/docker-shipfeeder:latest

echo ""
echo "[OK] SXFeeder en Docker instalado"
echo "Logs:"
echo "docker logs -f sxfeeder"
