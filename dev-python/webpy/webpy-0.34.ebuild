# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/webpy/webpy-0.34.ebuild,v 1.1 2010/05/25 10:28:24 djc Exp $

inherit distutils

MY_PN="web.py"

DESCRIPTION="A small and simple web framework for python"
HOMEPAGE="http://www.webpy.org"
SRC_URI="http://www.webpy.org/static/${MY_PN}-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=dev-lang/python-2.3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/web.py-${PV}"
PYTHON_MODNAME="web"

src_test() {
	TESTS="db template net http utils"

	cd "${S}"

	for TEST in ${TESTS}
	do
		${python} web/${TEST}.py || die "Doctest in web/${TEST}.py failed!"
	done
}
