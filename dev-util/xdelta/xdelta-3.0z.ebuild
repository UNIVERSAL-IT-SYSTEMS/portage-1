# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xdelta/xdelta-3.0z.ebuild,v 1.1 2010/09/15 01:17:11 xmw Exp $

EAPI=2

PYTHON_DEPEND="2:2.6"

inherit distutils toolchain-funcs

DESCRIPTION="a binary diff and differential compression tools. VCDIFF (RFC 3284) delta compression."
HOMEPAGE="http://xdelta.org"
SRC_URI="http://${PN}.googlecode.com/files/${P/-}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/sed"

S=${WORKDIR}/${P/-}
DOCS="draft-korn-vcdiff.txt"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	sed -i -e 's:-O3:-Wall:' setup.py || die "setup.py sed failed"
	sed \
		-e 's:-O3::g' \
		-e 's:$(CC):$(CC) $(LDFLAGS):g' \
		-e 's:CFLAGS=:CFLAGS+=:' \
		-i Makefile || die "Makefile sed failed"
}

src_test() {
	if [ $UID != 0 ]; then
		emake test || die "emake test failed"
	else
		ewarn "Tests can't be run as root, skipping."
	fi
}

src_compile() {
	tc-export CC CXX
	distutils_src_compile
	emake xdelta3 || die "emake xdelta3 failed"
	if use test; then
		emake xdelta3-debug || die "emake xdelta3-debug failed"
	fi
}

src_install() {
	dobin xdelta3 || die "dobin failed"
	distutils_src_install
}
