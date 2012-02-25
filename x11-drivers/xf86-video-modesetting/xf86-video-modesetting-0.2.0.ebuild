# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-modesetting/xf86-video-modesetting-0.2.0.ebuild,v 1.1 2012/02/25 01:32:35 chithanh Exp $

EAPI=4

XORG_DRI="dri"
inherit xorg-2

DESCRIPTION="Unaccelerated generic driver for kernel modesetting"

KEYWORDS="~amd64 ~x86"
IUSE="dri"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS="$(use_enable dri)"
}
