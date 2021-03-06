# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/abook/abook-0.5.6-r1.ebuild,v 1.7 2010/01/25 02:43:45 tgall Exp $

EAPI=2

inherit eutils

DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client."
HOMEPAGE="http://abook.sourceforge.net/"
SRC_URI="mirror://sourceforge/abook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-01_editor.patch
}

src_configure() {
	econf $(use_enable nls) || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc BUGS ChangeLog FAQ README TODO \
		sample.abookrc || die "dodoc failed"
}
