# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nstats/nstats-0.4-r1.ebuild,v 1.3 2011/12/13 19:02:17 jer Exp $

inherit eutils

DESCRIPTION="Displays statistics about ethernet traffic including protocol breakdown"
SRC_URI="http://trash.net/~reeler/nstats/files/${P}.tar.gz"
HOMEPAGE="http://trash.net/~reeler/nstats/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

DEPEND="net-libs/libpcap"

src_unpack(){
	unpack ${A}
	#rename bmon to bmon.nstats to avoid conflict with net-analyzer/bmon
	epatch "${FILESDIR}"/${P}-makefile.patch
	if has_version '>=sys-libs/glibc-2.4' ; then
		epatch "${FILESDIR}"/${P}-glibc24.patch
	fi
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc BUGS doc/TODO doc/ChangeLog
}
