# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mkfontscale/mkfontscale-1.0.8.ebuild,v 1.1 2010/10/31 12:53:32 scarabeus Exp $

EAPI=3
XORG_STATIC=no
inherit xorg-2

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libfontenc
	media-libs/freetype:2"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-arch/gzip
	app-arch/bzip2"

CONFIGURE_OPTIONS="--with-bzip2"
