# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dragonplayer/dragonplayer-4.5.1.ebuild,v 1.3 2010/09/06 04:50:54 reavertm Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="Dragon Player is a simple video player for KDE 4"
HOMEPAGE="http://www.dragonplayer.net/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="debug"

RDEPEND="
	aqua? ( >=media-libs/xine-lib-1.1.9 )
	!aqua? ( >=media-libs/xine-lib-1.1.9[xcb] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
