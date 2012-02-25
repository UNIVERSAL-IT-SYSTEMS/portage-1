# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/pyephem/pyephem-3.7.5.1.ebuild,v 1.2 2012/02/25 02:47:03 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython 2.7-pypy-*"

inherit distutils eutils

DESCRIPTION="Astronomical routines for the python programming language"
LICENSE="LGPL-3"
HOMEPAGE="http://rhodesmill.org/pyephem/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"
RDEPEND=""
DEPEND="doc? ( dev-python/sphinx )"

src_prepare() {
	# don't install rst files
	sed -i -e "s:'doc/\*\.rst',::" "${S}"/setup.py || die
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc; then
		cd src/ephem/doc
		PYTHONPATH=../../.. emake html || die "Building of documentation failed"
	fi
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r src/ephem/doc/.build/html/* || die "Installation of documentation failed"
	fi
}
