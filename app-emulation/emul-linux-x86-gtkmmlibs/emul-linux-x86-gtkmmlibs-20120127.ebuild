# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-gtkmmlibs/emul-linux-x86-gtkmmlibs-20120127.ebuild,v 1.2 2012/03/09 14:55:25 ssuominen Exp $

EAPI="4"

inherit emul-linux-x86

LICENSE="LGPL-2 LGPL-2.1 GPL-2"
KEYWORDS="-* amd64"

DEPEND=""
RDEPEND="~app-emulation/emul-linux-x86-baselibs-${PV}
	~app-emulation/emul-linux-x86-cpplibs-${PV}
	~app-emulation/emul-linux-x86-gtklibs-${PV}"
