# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libplasmagenericshell/libplasmagenericshell-4.8.1.ebuild,v 1.2 2012/03/31 13:58:59 maekke Exp $

EAPI=4

KMNAME="kde-workspace"
KMMODULE="libs/plasmagenericshell"
inherit kde4-meta

DESCRIPTION="Libraries for the KDE Plasma shell"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

DEPEND="
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep libkworkspace)
"

RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/kephal/
	plasma/desktop/shell/data/
"
