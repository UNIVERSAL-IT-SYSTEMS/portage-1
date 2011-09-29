# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblrdf/liblrdf-0.4.0_p20110928.ebuild,v 1.2 2011/09/28 22:45:07 ssuominen Exp $

EAPI=4
inherit autotools

DESCRIPTION="A library for the manipulation of RDF file in LADSPA plugins"
HOMEPAGE="http://lrdf.sourceforge.net/ http://github.com/swh/LRDF"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-1
	media-libs/raptor:2
	>=media-libs/ladspa-sdk-1.12"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	# http://github.com/swh/LRDF/issues/6
	sed -i -e '/^Libs/s:Private:private:' lrdf.pc.in || die
	# http://github.com/swh/LRDF/issues/5
	mkdir m4
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/liblrdf.la
}
