The 10GB Aquantia NICs on the Qualcomm SA8540p Development Boards (QDrive3) come
up with the same hardware MAC address of `00:17:b6:00:00:00`. We have multiple
development boards in the Red Hat lab and this will not work for us since we can't
have the same MAC address show up on the same LAN multiple times.

This RPM package uses systemd-networkd to rewrite the `00:17:b6:00:00:00` MAC address
into one that's based on the board serial number. A systemd-networkd link file
`/run/systemd/network/10-aquantia-10gb.link` is created with contents similar to the
following:

    [Match]
    PermanentMACAddress=00:17:b6:00:00:00
        
    [Link]
    MACAddress=00:17:b6:50:72:49

systemd-networkd expects this file to be static, and does not have the ability to
dynamically inject a new MAC address. This RPM provides a script that'll dynamically
create a MAC address within the Aquantia OUI. This script is automatically executed
as a post install scriptlet after the RPM is installed. It's also ran during bootup
before the networking is started. This will ensure that each board keeps the same
MAC address that's unique across the fleet.

Note that this RPM is just a workaround until we find a solution from Qualcomm about
how to program a MAC address into our boards.

The following patch was posted upstream in order to have the kernel automatically
assign a random MAC address when `00:17:b6:00:00:00` was encountered in the
Aquantia NIC driver:
[net: atlantic: fix check for invalid ethernet addresses](https://lore.kernel.org/lkml/20221130174259.1591567-1-bmasney@redhat.com/).
This patch was rejected upstream since technically that is a valid MAC address. The
fix for this does not belong in the kernel.

# Building

Type `make rpm` to build and the generated RPM will be in `~/rpmbuild/RPMS/noarch/`.
