# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpasswdserver/kpasswdserver-4.8.1.ebuild,v 1.2 2012/03/23 22:29:42 johu Exp $

EAPI=4

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDED Password Module"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

RESTRICT="test"
# bug 393097
