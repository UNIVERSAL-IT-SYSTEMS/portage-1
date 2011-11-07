# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/libnfs/libnfs-9999.ebuild,v 1.1 2011/11/06 23:17:33 vapier Exp $

EAPI="4"

inherit autotools
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/sahlberg/libnfs.git"
	inherit git-2
else
	SRC_URI="https://github.com/sahlberg/${PN}/tarball/${P} -> ${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0"
IUSE="static-libs"

RDEPEND="net-libs/libtirpc"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	default
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
	else
		mv sahlberg-libnfs-* "${S}" || die
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--enable-tirpc \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
