# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-mga/xf86-video-mga-1.5.0.ebuild,v 1.2 2012/05/16 00:52:47 aballier Exp $

EAPI=4
XORG_DRI=dri
inherit xorg-2

DESCRIPTION="Matrox video driver"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.4"
DEPEND="${RDEPEND}"

pkg_setup() {
	CONFIGURE_OPTIONS="$(use_enable dri)"
}
