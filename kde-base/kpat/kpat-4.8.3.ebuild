# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpat/kpat-4.8.3.ebuild,v 1.4 2012/05/24 09:30:46 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdegames"
KDE_SELINUX_MODULE="games"
inherit kde4-meta

DESCRIPTION="KDE patience game"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
