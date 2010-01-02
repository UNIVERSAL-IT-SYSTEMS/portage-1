# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/aespipe/aespipe-2.3e.ebuild,v 1.6 2010/01/01 19:56:57 fauli Exp $

inherit flag-o-matic

DESCRIPTION="Encrypts data from stdin to stdout"
HOMEPAGE="http://loop-aes.sourceforge.net"
SRC_URI="http://loop-aes.sourceforge.net/aespipe/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="static"
DEPEND=""
RDEPEND="app-arch/sharutils"

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	use static && append-ldflags -static
	econf || die
	emake || die
}

src_install() {
	dobin aespipe bz2aespipe
	dodoc README
	doman aespipe.1
}
