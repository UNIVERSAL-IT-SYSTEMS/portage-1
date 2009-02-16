# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xlhtml/xlhtml-0.5.1_p6.ebuild,v 1.1 2009/02/15 18:05:50 patrick Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools

MY_PV=${PV/_p*/}
DEB_PR=${PV/*_p/}

DESCRIPTION="Convert MS Excel and Powerpoint files to HTML"
HOMEPAGE="http://chicago.sourceforge.net/xlhtml/ http://packages.debian.org/etch/xlhtml/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PN}_${MY_PV}-${DEB_PR}.diff
	# This is needed specifically for depcomp, which is necessary for
	# building xlhtml, but isn't included.
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed for ${P}"
	dodoc AUTHORS INSTALL README
	docinto cole
	dodoc cole/{AUTHORS,COPYING,NEWS,ChangeLog,THANKS,TODO}
	docinto ppthtml
	dodoc ppthtml/{ChangeLog,README,THANKS}
	docinto xlhtml
	dodoc xlhtml/{ChangeLog,README,THANKS,TODO}
	rm -rf xlhtml/contrib/CVS
	cp -pPR xlhtml/contrib "${D}"/usr/share/doc/${PF}/xlhtml
}
