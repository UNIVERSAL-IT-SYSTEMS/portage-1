# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvbpsi/libdvbpsi-0.2.2.ebuild,v 1.2 2012/05/29 13:22:55 aballier Exp $

EAPI=4

DESCRIPTION="library for MPEG TS/DVB PSI tables decoding and generation"
HOMEPAGE="http://www.videolan.org/libdvbpsi"
SRC_URI="http://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="
	doc? (
		app-doc/doxygen
		>=media-gfx/graphviz-2.26
	)" # Require recent enough graphviz wrt #181147

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -e '/CFLAGS/s:-O2::' -e '/CFLAGS/s:-O6::' -i configure || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-release
}

src_compile() {
	emake
	use doc && emake doc
}

src_install() {
	default
	use doc && dohtml doc/doxygen/html/*
	rm -f "${ED}"usr/lib*/${PN}.la
}
