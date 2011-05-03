# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quimup/quimup-1.2.0.ebuild,v 1.5 2011/05/03 09:57:47 tomka Exp $

EAPI=3
inherit eutils qt4-r2

MY_P=${PN}_${PV}

DESCRIPTION="A Qt4 client for the music player daemon (MPD) written in C++"
HOMEPAGE="http://mpd.wikia.com/wiki/Client:Quimup"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}_source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/qt-gui
	>=media-libs/libmpdclient-2.2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e "/FLAGS/d" ${PN}.pro || die
}

src_install() {
	dobin ${PN} || die "dobin failed"
	dodoc changelog FAQ.txt README || die "dodoc failed"

	insinto /usr/share/pixmaps/
	newins Icons/${PN}64.png ${PN}.png || die "newins failed"

	make_desktop_entry ${PN} Quimup
}
