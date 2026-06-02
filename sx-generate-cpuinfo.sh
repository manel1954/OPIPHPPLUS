#!/bin/bash

set -e

SERIAL=$(cat /etc/sxfeeder.serial)

mkdir -p /run/sxfeeder-fake

cat /proc/cpuinfo > /run/sxfeeder-fake/cpuinfo

sed -i '/Serial/d' /run/sxfeeder-fake/cpuinfo

echo "Serial          : ${SERIAL:0:16}" >> /run/sxfeeder-fake/cpuinfo
