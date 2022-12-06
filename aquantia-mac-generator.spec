Name:		aquantia-mac-generator
Version:	1.0
Release:        1%{?dist}
Summary:	Correct Aquantia 10GB MAC address with trailing zeros
BuildArch:	noarch
License:	GPLv2
URL:		https://gitlab.cee.redhat.com/bmasney/aquantia-mac-generator
Source0:	%{name}-%{version}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Generates a systemd-networkd link file with a random MAC address based
on the SoC's serial number for the 10GB Aquantia NICs that come up with
a MAC address of 00:17:b6:00:00:00.


%prep
%setup -q


%install
rm -rf "$RPM_BUILD_ROOT"
mkdir -p "$RPM_BUILD_ROOT/etc/systemd/system/" "$RPM_BUILD_ROOT/usr/bin/"
cp aquantia-mac-generator.service "$RPM_BUILD_ROOT/etc/systemd/system/aquantia-mac-generator.service"
cp aquantia-mac-generator.sh "$RPM_BUILD_ROOT/usr/bin/"


%post
/usr/bin/aquantia-mac-generator.sh


%postun
rm -f /etc/systemd/network/10-aquantia-10gb.link


%clean
rm -rf "$RPM_BUILD_ROOT"


%files
/etc/systemd/system/aquantia-mac-generator.service
/usr/bin/aquantia-mac-generator.sh


%changelog
* Thu Dec 1 2022 Brian Masney <bmasney@redhat.com> 1.0
- First commit!
