# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yajl/yajl-2.0.4.ebuild,v 1.2 2012/05/18 08:47:52 aballier Exp $

EAPI=4

inherit base cmake-utils

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-fix_static_linking.patch
)

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/lloyd-${PN}-* "${S}"
}

src_test() {
	emake -C "${CMAKE_BUILD_DIR}" test
}

src_install() {
	cmake-utils_src_install
}
