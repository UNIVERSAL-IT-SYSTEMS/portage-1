# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Search-Xapian/Search-Xapian-1.2.8.ebuild,v 1.5 2012/03/24 16:59:58 phajdan.jr Exp $

EAPI=3

MODULE_AUTHOR=OLLY
MODULE_VERSION=1.2.8.0
inherit perl-module toolchain-funcs

DESCRIPTION="Perl XS frontend to the Xapian C++ search library."

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

RDEPEND=">=dev-libs/xapian-1.2.8
	!dev-libs/xapian-bindings[perl]"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST="do"

myconf="CXX=$(tc-getCXX) CXXFLAGS=${CXXFLAGS}"

src_install() {
	perl-module_src_install

	use examples && {
		docinto examples
		dodoc "${S}"/examples/*
	}
}
