# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lsyncd/lsyncd-2.0.4-r1.ebuild,v 1.2 2012/05/31 02:34:22 zmedico Exp $

EAPI=3

inherit base autotools multilib

DESCRIPTION="Live Syncing (Mirror) Daemon"
HOMEPAGE="http://code.google.com/p/lsyncd/"
SRC_URI="http://lsyncd.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-lang/lua"
RDEPEND="${DEPEND}
	net-misc/rsync"

PATCHES=( "${FILESDIR}/${P}-examplesdir.patch" )

src_prepare() {
	base_src_prepare
	eautoreconf
}
src_configure() {
	econf \
		--with-runner="${EPREFIX}/usr/$(get_libdir)/${PN}" \
		--docdir=/usr/share/doc/${P}
}
