# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/spectrwm/spectrwm-1.0.0.ebuild,v 1.2 2012/02/18 03:34:10 xmw Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="Small dynamic tiling window manager for X11"
HOMEPAGE="https://opensource.conformal.com/wiki/spectrwm"
SRC_URI="http://opensource.conformal.com/snapshots/${PN}/${P}.tgz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/dmenu"
DEPEND="${DEPEND}
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXtst
	!x11-wm/scrotwm"

S=${WORKDIR}/${P}/linux

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	tc-export CC
}

src_install() {
	emake PREFIX="${D}"/usr LIBDIR="${D}usr/$(get_libdir)" install

	cd ${WORKDIR}/${P} || die

	insinto /etc
	doins ${PN}.conf
	dodoc ${PN}_*.conf {initscreen,screenshot}.sh

	elog "Example keyboard config and helpful scripts can be found"
	elog "in ${ROOT}usr/share/doc/${PF}"
}
