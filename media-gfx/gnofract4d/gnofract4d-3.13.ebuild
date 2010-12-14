# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnofract4d/gnofract4d-3.13.ebuild,v 1.3 2010/12/14 15:56:12 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils fdo-mime

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://gnofract4d.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=media-libs/libpng-1.4
	virtual/jpeg
	>=dev-python/pygtk-2
	>=gnome-base/gconf-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PYTHON_MODNAME="fract4d fractutils fract4dgui"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.12-libpng14.patch
	distutils_src_prepare
}

src_install() {
	distutils_src_install
	rm -rf "${D}"/usr/share/doc/${PN}
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
