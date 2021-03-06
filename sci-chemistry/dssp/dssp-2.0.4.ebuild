# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/dssp/dssp-2.0.4.ebuild,v 1.1 2012/06/03 15:06:13 jlec Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="http://swift.cmbi.ru.nl/gv/dssp/"
SRC_URI="ftp://ftp.cmbi.ru.nl/pub/molbio/software/dssp-2/dssp-2.0.4.tgz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	tc-export CXX

	cat >> make.config <<- EOF
	BOOST_LIB_SUFFIX = -mt
	BOOST_LIB_DIR = "${EPREFIX}/usr/$(get_libdir)"
	BOOST_INC_DIR = "${EPREFIX}/usr/include"
	EOF

	epatch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-gentoo.patch
}

src_install() {
	dobin mkdssp
	dosym mkdssp /usr/bin/dssp
	doman doc/mkdssp.1
	dodoc README.txt changelog
}
