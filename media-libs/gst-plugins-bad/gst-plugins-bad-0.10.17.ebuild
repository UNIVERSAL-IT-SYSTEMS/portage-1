# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-bad/gst-plugins-bad-0.10.17.ebuild,v 1.7 2010/04/18 15:53:43 nixnut Exp $

inherit gst-plugins-bad gnome2 eutils flag-o-matic libtool

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.25
	>=media-libs/gstreamer-0.10.25
	>=dev-libs/glib-2.16
	!<media-plugins/gst-plugins-farsight-0.12.11"

DEPEND="${RDEPEND}"

src_compile() {
	strip-flags
	replace-flags "-O3" "-O2"
	filter-flags "-fprefetch-loop-arrays" # (Bug #22249)

	gst-plugins-bad_src_configure

	emake || die "emake failed."
}

src_install() {
	gnome2_src_install
}

DOCS="AUTHORS ChangeLog NEWS README RELEASE"

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
