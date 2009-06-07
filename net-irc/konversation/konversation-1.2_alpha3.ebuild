# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/konversation/konversation-1.2_alpha3.ebuild,v 1.2 2009/06/05 23:28:17 tampakrap Exp $

EAPI="2"

inherit kde4-base versionator

MY_P="${PN}"-$(replace_version_separator 2 '-')

DESCRIPTION="A user friendly IRC Client for KDE4"
HOMEPAGE="http://konversation.kde.org"
SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND=">=kde-base/kdepimlibs-${KDE_MINIMAL}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
