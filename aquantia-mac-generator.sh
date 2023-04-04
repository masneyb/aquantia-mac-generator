#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0

# Grab the board serial number given by androidboot.serialno in /proc/cmdline
# and use that to generate a random MAC address that will be stable for
# this particular system.

set -e

OUI="00:17:b6"

__SN="$(</proc/cmdline)"
_SN="${__SN##*androidboot.serialno=}"

NEW_MAC=""

if [ -z "$_SN" ]
then # Use machine-id as fallback if serial number is not present
    MI=$(cat /etc/machine-id)
    NEW_MAC="${OUI}:${MI:0:2}:${MI:2:2}:${MI:4:2}"
else
    SN="${_SN%% *}"
    NEW_MAC="${OUI}:${SN:0:2}:${SN:2:2}:${SN:4:2}"
fi

mkdir -p /run/systemd/network/
cat > /run/systemd/network/10-aquantia-10gb.link << __EOF__
[Match]
PermanentMACAddress=00:17:b6:00:00:00
    
[Link]
MACAddress=${NEW_MAC}
__EOF__

echo "Created 10-aquantia-10gb.link file with MAC address ${NEW_MAC}"
