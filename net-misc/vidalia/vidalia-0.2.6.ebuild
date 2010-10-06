# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vidalia/vidalia-0.2.6.ebuild,v 1.2 2010/10/06 02:34:58 chiiph Exp $

EAPI="2"

inherit eutils qt4-r2 cmake-utils
# cmake-utils needs to be last, so we get its src_compile()

DESCRIPTION="Qt 4 front-end for Tor"
HOMEPAGE="https://www.torproject.org/vidalia/"
SRC_URI="https://www.torproject.org/vidalia/dist/${P}.tar.gz"

LICENSE="|| ( GPL-3 GPL-2 ) openssl"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug +tor"

DEPEND="x11-libs/qt-gui:4[debug?]"
RDEPEND="${DEPEND}
	tor? ( net-misc/tor )"

DOCS="CHANGELOG CREDITS README"

pkg_postinst() {
	echo
	if use tor; then
		ewarn "To have vidalia starting tor, you probably have to copy"
	    ewarn "/etc/tor/torrc.sample to the users ~/.tor/torrc and comment"
	    ewarn "the settings there and change the socks. Also, in vidalia"
	    ewarn "change the default user under which tor will run."
	else
		ewarn "You have disabled tor USE flag, which means you need to "
		ewarn "configure tor on a different host."
	fi
	elog ""
	elog "You are installing a development release version, to install"
	elog "upstream stable release use 0.1.x"
	elog "Refer to ${HOMEPAGE} for more info"
}
