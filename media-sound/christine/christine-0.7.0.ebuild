# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/christine/christine-0.7.0.ebuild,v 1.1 2012/02/15 00:09:28 ssuominen Exp $

EAPI=4

PYTHON_DEPEND="2:2.7"
PYTHON_USE_WITH="sqlite"

inherit autotools eutils python

DESCRIPTION="A simple gstreamer based media player"
HOMEPAGE="http://christine-project.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify nls readline"

COMMON_DEPEND="=dev-python/gst-python-0.10*
	dev-python/pycairo
	dev-python/pygobject:2
	=dev-python/pygtk-2*
	media-libs/mutagen
	libnotify? ( dev-python/notify-python )
	readline? ( sys-libs/readline )"
RDEPEND="${COMMON_DEPEND}
	=media-plugins/gst-plugins-meta-0.10*"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	nls? ( dev-util/intltool )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-validate.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable nls) $(use_with readline)
}

pkg_postinst() { python_mod_optimize libchristine; }
pkg_postrm() { python_mod_cleanup libchristine; }
