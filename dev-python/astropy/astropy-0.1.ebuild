# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/astropy/astropy-0.1.ebuild,v 1.1 2012/06/19 16:01:30 xarthisius Exp $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST=setup.py

inherit eutils distutils

DESCRIPTION="Collection of common tools needed for performing astronomy and astrophysics"
HOMEPAGE="http://astropy.org/ https://github.com/astropy/astropy"
SRC_URI="http://github.com/downloads/${PN}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="dev-libs/expat
	dev-python/numpy"
DEPEND="${RDEPEND}
	dev-python/configobj
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest )"

src_prepare() {
	# Remove most of the bundled deps
	rm -rf cextern ${PN}/extern
	export ASTROPY_USE_SYSTEM_PYTEST=1
	epatch "${FILESDIR}"/${P}-expat.patch
	sed -e 's/from ..extern.configobj //g' \
		-i astropy/config/configuration.py || die
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	if use doc; then
		PYTHONPATH=$(ls -d "${S}"/build-$(PYTHON -f --ABI)/lib*) emake html -C docs
	fi
}

src_install() {
	distutils_src_install
	use doc && dohtml -r docs/_build/html/
}
