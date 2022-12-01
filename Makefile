# SPDX-License-Identifier: GPL-2.0

.PHONY: rpm

rpm: $(HOME)/rpmbuild/SOURCES
	git archive --format=tar.gz --prefix aquantia-mac-generator-1.0/ HEAD > ~/rpmbuild/SOURCES/aquantia-mac-generator-1.0.tar.gz
	rpmbuild -ba aquantia-mac-generator.spec

$(HOME)/rpmbuild/SOURCES:
	rpmdev-setuptree
