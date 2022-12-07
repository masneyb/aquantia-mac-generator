# SPDX-License-Identifier: GPL-2.0

VERSION=1.1

.PHONY: dist rpm

dist:
	git archive --format=tar.gz --prefix "aquantia-mac-generator-${VERSION}/" HEAD > "aquantia-mac-generator-${VERSION}.tar.gz"

rpm: $(HOME)/rpmbuild/SOURCES dist
	mv "aquantia-mac-generator-${VERSION}.tar.gz" ~/rpmbuild/SOURCES/
	rpmbuild -ba aquantia-mac-generator.spec

$(HOME)/rpmbuild/SOURCES:
	rpmdev-setuptree
