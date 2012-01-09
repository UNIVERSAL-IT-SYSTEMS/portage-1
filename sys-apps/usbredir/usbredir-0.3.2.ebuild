# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbredir/usbredir-0.3.2.ebuild,v 1.1 2012/01/09 07:27:11 ssuominen Exp $

EAPI=4

DESCRIPTION="A server and libraries for redirecting USB traffic"
HOMEPAGE="http://spice-space.org/page/UsbRedir"
SRC_URI="http://spice-space.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

#RDEPEND="virtual/libusb:1"
RDEPEND=">=dev-libs/libusb-1.0.9_rc"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="ChangeLog README* TODO *.txt"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/lib*.la
}
