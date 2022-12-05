The 10GB Aquantia NICs on the QDrive3 development boards in the Red Hat lab all come
up with the same hardware MAC address of `00:17:b6:00:00:00`. This will obviously not
work for us since we have multiple boards in the lab on the same LAN.

This RPM package creates a systemd-networkd link file
`/etc/systemd/network/10-aquantia-10gb.link` with contents similar to the following:

    [Match]
    PermanentMACAddress=00:17:b6:00:00:00
        
    [Link]
    MACAddress=00:17:b6:8e:81:52

systemd-networkd expects this file to be static, and does not have the ability to
dynamically inject a new MAC address. This RPM provides a script that's packaged up
in a RPM that'll dynamically create a random MAC address within the Aquantia OUI
based on the SoC's serial number. This script is automatically executed as a post
install scriptlet after the RPM is installed. This will ensure that each board
keeps the same MAC address that's unique across the fleet.

Note that this RPM is just a workaround until we find a solution from Qualcomm or
Marvell about how to program a MAC address into our boards.

To build a noarch RPM, type `make rpm`.
