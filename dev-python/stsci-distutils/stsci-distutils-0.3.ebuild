# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/stsci-distutils/stsci-distutils-0.3.ebuild,v 1.3 2012/03/10 16:15:48 jlec Exp $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

inherit distutils

DESCRIPTION="Utilities used to package some of STScI's Python projects"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/stsci_python
	http://pypi.python.org/pypi/stsci.distutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	dev-python/d2to1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
