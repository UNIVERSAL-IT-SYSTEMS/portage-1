# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/iat/iat-0.1.7-r1.ebuild,v 1.3 2011/06/11 12:01:26 maekke Exp $

EAPI="2"

DESCRIPTION="BIN, MDF, PDI, CDI, NRG, and B5I converters"
HOMEPAGE="http://iat.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE=""

src_configure() {
	econf  \
		--disable-dependency-tracking \
		--includedir=/usr/include/${PN}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS README || die "dodoc failed"
}
