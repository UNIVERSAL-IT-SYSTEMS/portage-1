# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/yawp/yawp-0.4.1.ebuild,v 1.1 2011/12/24 12:58:17 johu Exp $

EAPI=4
KDE_LINGUAS="af cs de es fr he it pl ru sk sl tr uk"
inherit kde4-base

DESCRIPTION="Yet Another Weather Plasmoid"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=94106"
SRC_URI="mirror://sourceforge/yawp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="$(add_kdebase_dep plasma-workspace)"

DOCS=( README TODO CHANGELOG )
