# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbugbuster/kbugbuster-3.5.10.ebuild,v 1.4 2009/06/06 10:37:38 maekke Exp $

KMNAME=kdesdk
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KBugBuster - A tool for checking and reporting KDE apps' bugs"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kcal kdehiddenvisibility"

DEPEND="kcal? ( || ( >=kde-base/libkcal-${PV}:${SLOT} >=kde-base/kdepim-${PV}:${SLOT} ) )"

#TODO tell configure about the optional kcal support, or something
