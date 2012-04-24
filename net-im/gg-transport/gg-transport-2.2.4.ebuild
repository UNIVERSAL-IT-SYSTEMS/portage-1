# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gg-transport/gg-transport-2.2.4.ebuild,v 1.6 2012/04/23 20:27:27 mgorny Exp $

DESCRIPTION="Gadu-Gadu transport for Jabber"
HOMEPAGE="https://github.com/Jajcus/jggtrans"
SRC_URI="mirror://github/Jajcus/jggtrans/jggtrans-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=net-im/jabber-base-0.01
	>=dev-libs/glib-2.6.4
	net-dns/libidn
	>=net-libs/libgadu-1.9.0_rc3
	dev-libs/expat"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/jggtrans-${PV}"

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	keepdir /var/spool/jabber/gg
	keepdir /var/run/jabber
	keepdir /var/log/jabber
	fowners jabber:jabber /var/spool/jabber/gg
	fowners jabber:jabber /var/run/jabber
	fowners jabber:jabber /var/log/jabber

	newinitd "${FILESDIR}/jggtrans-${PVR}" jggtrans

	insinto /etc/jabber
	doins jggtrans.xml

	sed -i \
		-e 's,/var/lib/jabber/spool/gg.localhost/,/var/spool/jabber/gg/,' \
		-e 's,/var/lib/jabber/ggtrans.pid,/var/run/jabber/jggtrans.pid,' \
		-e 's,/tmp/ggtrans.log,/var/log/jabber/jggtrans.log,' \
		"${D}/etc/jabber/jggtrans.xml" || die "sed failed"

	dodoc AUTHORS ChangeLog README README.Pl NEWS
}
