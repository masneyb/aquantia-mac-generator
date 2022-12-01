#!/usr/bin/env bash

# Grab the SoC serial number from sysfs, convert it to base16, reverse it so that the
# least significant bytes appear first, and use that to generate a random MAC address
# that will be stable for this particular system.

set -e

SN="$(printf "%x\n" "$(cat /sys/devices/soc0/serial_number)" | rev)"

cat > /etc/systemd/network/10-aquantia-10gb.link << __EOF__
[Match]
PermanentMACAddress=00:17:b6:00:00:00
    
[Link]
MACAddress=00:17:b6:${SN:0:2}:${SN:2:2}:${SN:4:2}
__EOF__
