# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/burrow-owl/burrow-owl-1.5.ebuild,v 1.2 2012/05/04 07:02:35 jdhore Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Visualize multidimensional nuclear magnetic resonance (NMR) spectra"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	examples? ( mirror://sourceforge/${PN}/burrow-demos.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"

RDEPEND="
	dev-libs/g-wrap
	dev-libs/glib:2
	dev-scheme/guile[networking,regex]
	dev-scheme/guile-cairo
	dev-scheme/guile-gnome-platform
	sci-libs/starparse
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/indent
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}"/${P}-prll.patch
	)

src_configure() {
	local myeconfargs=(
		$(use_with doc doxygen doxygen)
	)
	autotools-utils_src_configure
}

src_test () {
	autotools-utils_src_compile -C test-suite check
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/doc/api/html/")
	autotools-utils_src_install

	use examples && \
		insinto /usr/share/${PN} && \
		doins -r "${WORKDIR}"/burrow-demos/*
}
