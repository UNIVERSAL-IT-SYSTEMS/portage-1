# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ark/xf86-video-ark-0.7.4.ebuild,v 1.5 2012/06/24 19:03:56 ago Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="X.Org driver for ark cards"
KEYWORDS="amd64 ~ia64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	>=x11-libs/libpciaccess-0.12.901"
