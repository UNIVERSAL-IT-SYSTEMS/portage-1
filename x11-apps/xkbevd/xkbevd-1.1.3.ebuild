# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xkbevd/xkbevd-1.1.3.ebuild,v 1.1 2012/03/23 15:34:54 chithanh Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="XKB event daemon"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	sys-devel/bison"
