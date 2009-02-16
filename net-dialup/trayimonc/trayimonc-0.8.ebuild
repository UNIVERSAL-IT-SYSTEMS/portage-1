# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/trayimonc/trayimonc-0.8.ebuild,v 1.3 2009/02/15 20:33:20 loki_val Exp $

inherit kde eutils

DESCRIPTION="TrayImonc, a KDE based imond client for fli4l"
SRC_URI="http://www.trayimonc.de/downloads/${P}${V}.tar.bz2"
HOMEPAGE="http://www.trayimonc.de/"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="xinerama debug"

need-kde 3

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${P}-gcc43.patch
}

src_compile() {
	local myconf=""
	set-kdedir 3

	useq xinerama && \
		myconf="${myconf} --enable-Xinerama"
	useq debug && \
		myconf="${myconf} --enable-debug=full"

	econf $myconf && \
		emake || die "Compile has failed!"
}

src_install() {
	einstall || die "make install has failed"
}
