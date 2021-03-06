# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/flamerobin/flamerobin-0.9.2.ebuild,v 1.4 2012/03/03 12:01:19 pacho Exp $

EAPI="4"

WX_GTK_VER="2.8"
inherit eutils wxwidgets

DESCRIPTION="A database administration tool for Firebird DBMS"
HOMEPAGE="http://www.flamerobin.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="x11-libs/wxGTK:2.8[X]
	 dev-db/firebird"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-src"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc46.patch"
}

src_configure() {
	# temp hack since configure is not executable
	chmod +x configure

	local myconf
	myconf="${myconf} \
		--disable-shared \
		--disable-debug \
		--with-wx=yes \
		--with-wx-config=${WX_CONFIG}"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc devdocs/* docs/* docs-src/*
}
