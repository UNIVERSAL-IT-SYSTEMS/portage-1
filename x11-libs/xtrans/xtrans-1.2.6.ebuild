# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xtrans/xtrans-1.2.6.ebuild,v 1.2 2010/12/19 12:53:04 ssuominen Exp $

EAPI=3

PACKAGE_NAME="lib${PN}"
# this package just installs some .c and .h files, no libraries
XORG_STATIC=no
inherit xorg-2

DESCRIPTION="X.Org xtrans library"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-text/xmlto )"

pkg_setup() {
	CONFIGURE_OPTIONS="$(use_enable doc docs)
		$(use_with doc xmlto)
		--without-fop"
}
