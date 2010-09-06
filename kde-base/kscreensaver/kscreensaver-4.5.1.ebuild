# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kscreensaver/kscreensaver-4.5.1.ebuild,v 1.2 2010/09/06 04:51:15 reavertm Exp $

EAPI="3"

KMNAME="kdebase-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE screensaver framework"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug pam"

RDEPEND="
	dev-libs/glib:2
	$(add_kdebase_dep kcheckpass)
	>=x11-libs/libxklavier-3.2
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXtst
	opengl? ( virtual/opengl )
	pam? ( >=kde-base/kdebase-pam-7 )
"
DEPEND="${RDEPEND}
	x11-proto/randrproto
"

PATCHES=( "${FILESDIR}/kdebase-4.0.2-pam-optional.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with pam)
	)

	kde4-meta_src_configure
}
