# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kate/kate-4.5.1.ebuild,v 1.2 2010/09/06 04:51:19 reavertm Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="Kate is an MDI texteditor."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma"

DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with plasma)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kaddressbook:${SLOT}; then
		echo
		elog "File templates plugin requires kde-base/kaddressbook:${SLOT}."
		elog "Please install it if you plan to use this plugin."
		echo
	fi
}
