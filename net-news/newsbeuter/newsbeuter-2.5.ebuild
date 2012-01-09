# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/newsbeuter/newsbeuter-2.5.ebuild,v 1.1 2012/01/09 08:45:58 radhermit Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="A RSS/Atom feed reader for the text console"
HOMEPAGE="http://www.newsbeuter.org/index.html"
SRC_URI="http://www.${PN}.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.18.0
	dev-libs/json-c
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-lang/perl
	dev-util/pkgconfig
	sys-devel/gettext
	test? (
		dev-libs/boost
		sys-devel/bc
	)"

# Tests require network access
RESTRICT="test"

src_prepare() {
	sed -i \
		-e "s:-ggdb:${CXXFLAGS}:" \
		-e "s:^CXX=.*:CXX=$(tc-getCXX):" \
		Makefile
}

src_configure() {
	./config.sh || die
}

src_test() {
	emake test
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test
	./test || die
}

src_install() {
	emake prefix="${D}/usr" docdir="${D}/usr/share/doc/${PF}" install
	dodoc AUTHORS README CHANGES
}
