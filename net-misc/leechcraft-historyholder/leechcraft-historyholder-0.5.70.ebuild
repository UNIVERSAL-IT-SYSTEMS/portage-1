# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-historyholder/leechcraft-historyholder-0.5.70.ebuild,v 1.1 2012/05/31 20:55:50 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="HistoryHolder keeps track of stuff downloaded in LeechCraft"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-search-show"
