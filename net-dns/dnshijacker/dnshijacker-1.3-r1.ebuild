# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnshijacker/dnshijacker-1.3-r1.ebuild,v 1.7 2006/02/20 20:24:34 jokey Exp $

inherit eutils

DESCRIPTION="a libnet/libpcap based packet sniffer and spoofer"
HOMEPAGE="http://pedram.redhive.com/projects.php"
SRC_URI="http://pedram.redhive.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.0.2a-r3
	<net-libs/libnet-1.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-libnet-1.0.patch
	sed -i "s|gcc |gcc ${CFLAGS} |g" Makefile || die
}

src_compile() {
	make || die
}

src_install() {
	dosbin dnshijacker ask_dns answer_dns

	insinto /etc/dnshijacker
	doins ftable

	dodoc README
}
