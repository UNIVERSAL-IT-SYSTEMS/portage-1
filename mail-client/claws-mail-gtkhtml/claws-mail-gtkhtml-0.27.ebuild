# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-gtkhtml/claws-mail-gtkhtml-0.27.ebuild,v 1.5 2010/11/23 08:55:25 fauli Exp $

inherit eutils

MY_P="${PN#claws-mail-}2_viewer-${PV}"

DESCRIPTION="Renders HTML mail using the gtkhtml2 rendering widget."
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.7.6
		net-misc/curl"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --disable-accessibility || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
