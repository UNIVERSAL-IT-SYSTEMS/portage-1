# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libtaskmanager/libtaskmanager-4.3.4.ebuild,v 1.3 2010/01/23 17:06:25 armin76 Exp $

EAPI="2"

KMNAME="kdebase-workspace"
KMMODULE="libs/taskmanager"
inherit kde4-meta

DESCRIPTION="A library that provides basic taskmanager functionality"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kephal)
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"
