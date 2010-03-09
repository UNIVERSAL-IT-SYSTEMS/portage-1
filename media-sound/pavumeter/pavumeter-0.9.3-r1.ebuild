# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pavumeter/pavumeter-0.9.3-r1.ebuild,v 1.3 2010/03/08 20:25:48 maekke Exp $

EAPI=2

DESCRIPTION="PulseAudio Volume Meter, simple GTK volume meter for PulseAudio"
HOMEPAGE="http://0pointer.de/lennart/projects/pavumeter/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.4
	>=dev-libs/libsigc++-2.0
	>=media-sound/pulseaudio-0.9.7[glib]
	|| ( x11-themes/tango-icon-theme x11-themes/gnome-icon-theme )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-lynx
}

src_install() {
	emake DESTDIR="${D}" install || die
	dohtml -r doc
	dodoc README
}
