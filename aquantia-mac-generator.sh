#!/usr/bin/env bash

# Grab the SoC serial number from sysfs, convert it to base16, reverse it so that the
# least significant bytes appear first, and use that to generate a random MAC address
# that will be stable for this particular system.

set -e

RAW_SERIAL_NUM=$(cat /sys/devices/soc0/serial_number)
FORMATTED_SERIAL_NUM=$(printf '%x\n' "${RAW_SERIAL_NUM}" | rev)

FIRST=$(echo "${FORMATTED_SERIAL_NUM}" | cut -b1-2)
SECOND=$(echo "${FORMATTED_SERIAL_NUM}" | cut -b3-4)
THIRD=$(echo "${FORMATTED_SERIAL_NUM}" | cut -b5-6)

cat > /etc/systemd/network/10-aquantia-10gb.link << __EOF__
[Match]
PermanentMACAddress=00:17:b6:00:00:00
    
[Link]
MACAddress=00:17:b6:${FIRST}:${SECOND}:${THIRD}
__EOF__
