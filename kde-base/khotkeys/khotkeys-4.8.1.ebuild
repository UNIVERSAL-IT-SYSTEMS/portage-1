# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khotkeys/khotkeys-4.8.1.ebuild,v 1.2 2012/03/23 23:30:28 johu Exp $

EAPI=4

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE: hotkey daemon"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libs/kworkspace/
"
