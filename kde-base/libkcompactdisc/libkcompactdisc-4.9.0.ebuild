# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkcompactdisc/libkcompactdisc-4.9.0.ebuild,v 1.1 2012/08/01 22:17:15 johu Exp $

EAPI=4

KDE_SCM="git"
inherit kde4-base

DESCRIPTION="KDE library for playing & ripping CDs"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa)
	)
	kde4-base_src_configure
}
