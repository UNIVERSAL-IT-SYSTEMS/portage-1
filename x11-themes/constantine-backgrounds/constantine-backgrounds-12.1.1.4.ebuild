# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/constantine-backgrounds/constantine-backgrounds-12.1.1.4.ebuild,v 1.2 2012/01/23 15:59:55 ago Exp $

EAPI=3

inherit versionator rpm

SRC_PATH=development/15/source/SRPMS
FEDORA=15

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F12_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CCPL-Attribution-ShareAlike-2.0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="!x11-themes/fedora-backgrounds:12"
DEPEND=""

S="${WORKDIR}/${MY_P}"

SLOT="0"

src_unpack() {
	rpm_src_unpack

	# as of 2010-06-21 rpm.eclass does not unpack the further lzma
	# file automatically.
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
}
