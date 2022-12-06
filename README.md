The 10GB Aquantia NICs on the Qualcomm SA8540p Development Boards (QDrive3) come
up with the same hardware MAC address of `00:17:b6:00:00:00`. We have multiple
development boards in the Red Hat lab and this will not work for us since we can't
have the same MAC address show up on the same LAN multiple times.

This RPM package uses systemd-networkd to rewrite the `00:17:b6:00:00:00` MAC address
into one that's based on the SoC serial number. A systemd-networkd link file
`/etc/systemd/network/10-aquantia-10gb.link` is created with contents similar to the
following:

    [Match]
    PermanentMACAddress=00:17:b6:00:00:00
        
    [Link]
    MACAddress=00:17:b6:8e:81:52

systemd-networkd expects this file to be static, and does not have the ability to
dynamically inject a new MAC address. This RPM provides a script that's packaged up
in a RPM that'll dynamically create a MAC address within the Aquantia OUI based on
the SoC's serial number. This script is automatically executed as a post install
scriptlet after the RPM is installed. This will ensure that each board keeps the
same MAC address that's unique across the fleet.

Note that this RPM is just a workaround until we find a solution from Qualcomm about
how to program a MAC address into our boards.

The following patch was posted upstream in order to have the kernel automatically
assign a random MAC address when `00:17:b6:00:00:00` was encountered in the
Aquantia NIC driver:
[net: atlantic: fix check for invalid ethernet addresses](https://lore.kernel.org/lkml/20221130174259.1591567-1-bmasney@redhat.com/).
This patch was rejected upstream since technically that is a valid MAC address. The
fix for this does not belong in the kernel.

# Limitation

Everything works as expected if you directly install this RPM on a SA8540P board. However,
if you install this RPM in a generic image that's meant to be flashed onto the SA8540P,
then the first time the machine boots, it'll come up with a MAC address of
`00:17:b6:00:00:00`. On the second boot, it'll come up with a different MAC address
as expected.

This is due to the dependency in the
[aquantia-mac-generator.service](aquantia-mac-generator.service) unit. The problem is
that this needs to be ran before the networking comes up, but after the filesystem
and kernel modules are loaded. Specifically, the
[qcom_socinfo](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/soc/qcom/socinfo.c)
kernel module needs to be loaded so that the SoC serial number can be looked up. I
tried the following dependencies but the system won't boot:

    After=systemd-modules-load.service
    Before=network-pre.target systemd-udevd.service
    Wants=network-pre.target

Suggestions are welcome about how to fix this!

# Building

Type `make rpm` to build and the generated RPM will be in `~/rpmbuild/RPMS/noarch/`.
