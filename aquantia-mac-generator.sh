#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0

# Grab the systemd machine id and use that to generate a random MAC address that will be
# stable for this particular system.

set -e

MI=$(cat /etc/machine-id)
NEW_MAC="00:17:b6:${MI:0:2}:${MI:2:2}:${MI:4:2}"

cat > /etc/systemd/network/10-aquantia-10gb.link << __EOF__
[Match]
PermanentMACAddress=00:17:b6:00:00:00
    
[Link]
MACAddress=${NEW_MAC}
__EOF__

echo "Created 10-aquantia-10gb.link file with MAC address ${NEW_MAC}"
