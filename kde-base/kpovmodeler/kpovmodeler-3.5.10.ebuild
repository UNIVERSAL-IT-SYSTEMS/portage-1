# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kpovmodeler/kpovmodeler-3.5.10.ebuild,v 1.4 2009/06/06 11:14:25 maekke Exp $

KMNAME=kdegraphics
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE: Modeler for POV-Ray Scenes."
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="virtual/opengl
	>=media-libs/freetype-2.3"
RDEPEND="${DEPEND}
	media-gfx/povray"
