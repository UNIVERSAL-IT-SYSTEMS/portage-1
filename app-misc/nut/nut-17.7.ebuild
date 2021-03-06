# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/nut/nut-17.7.ebuild,v 1.4 2012/06/07 21:30:33 ranger Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Record what you eat and analyze your nutrient levels"
HOMEPAGE="http://nut.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc x86"
IUSE="fltk"

RDEPEND="
	fltk? ( x11-libs/fltk:1 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-17.7-makefile.patch
}

src_compile() {
	emake CC=$(tc-getCC) FOODDIR=\\\"/usr/share/nut\\\"
	if use fltk; then
		cd fltk
		emake CXX=$(tc-getCXX) FOODDIR=\\\"/usr/share/nut\\\"
	fi
}

src_install() {
	insinto /usr/share/nut
	doins raw.data/*
	dobin nut
	doman nut.1
	if use fltk; then
		dobin fltk/Nut
		doicon nut.xpm
		make_desktop_entry Nut nut nut Education
	fi
}
