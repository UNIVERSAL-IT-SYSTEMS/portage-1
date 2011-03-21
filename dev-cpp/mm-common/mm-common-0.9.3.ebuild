# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/mm-common/mm-common-0.9.3.ebuild,v 1.2 2011/03/21 01:22:44 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Build infrastructure and utilities for GNOME C++ bindings"
HOMEPAGE="http://www.gtkmm.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	|| (
		net-misc/wget
		net-misc/curl )"
