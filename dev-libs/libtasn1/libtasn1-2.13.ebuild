# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtasn1/libtasn1-2.13.ebuild,v 1.1 2012/06/01 00:36:51 radhermit Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="ASN.1 library"
HOMEPAGE="http://www.gnu.org/software/libtasn1/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="doc static-libs"

DEPEND=">=dev-lang/perl-5.6
	sys-devel/bison"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_configure(){
	local myeconfargs
	[[ "${VALGRIND_TESTS}" == "0" ]] && myeconfargs+=( --disable-valgrind-tests )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use doc ; then
		dodoc doc/libtasn1.pdf
		dohtml doc/reference/html/*
	fi
}
