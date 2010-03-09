# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/httplib2/httplib2-0.6.0.ebuild,v 1.5 2010/03/08 10:47:38 djc Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="http://code.google.com/p/httplib2/ http://pypi.python.org/pypi/httplib2"
SRC_URI="http://httplib2.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	distutils_src_install

	dodoc README
	newdoc python3/README README-python3
}

src_test() {
	testing() {
		cd "$S/python${PYTHON_ABI:0:1}"
		"$(PYTHON)" httplib2test.py
		cd ../..
	}
	python_execute_function testing
}
