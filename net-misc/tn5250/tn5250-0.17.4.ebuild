# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tn5250/tn5250-0.17.4.ebuild,v 1.2 2009/04/30 19:34:01 ranger Exp $

inherit eutils python

DESCRIPTION="Telnet client for the IBM AS/400 that emulates 5250 terminals and printers."
HOMEPAGE="http://tn5250.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc ~x86"
IUSE="X ssl"

RDEPEND="sys-libs/ncurses
	ssl? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	X? ( x11-libs/libXt )"

src_unpack() {
	unpack ${A}

	# Next, the Makefile for the terminfo settings tries to remove
	# some files it doesn't have access to.	 We can just remove those
	# lines.
	cd "${S}/linux"
	sed -i \
		-e "/rm -f \/usr\/.*\/terminfo.*5250/d" Makefile.in \
		|| die "sed Makefile.in failed"
	cd "${S}"
}

src_compile() {
	econf \
		$(use_with X x) \
		$(use_with ssl) || die
	emake || die "emake failed"
}

src_install() {
	# The TERMINFO variable needs to be defined for the install
	# to work, because the install calls "tic."	 man tic for
	# details.
	dodir /usr/share/terminfo
	make DESTDIR="${D}" \
		 TERMINFO="${D}/usr/share/terminfo" install \
		 || die "make install failed"

	dodoc AUTHORS BUGS NEWS README README.ssl TODO ChangeLog
}
