# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rasqal/rasqal-0.9.26.ebuild,v 1.1 2011/07/09 08:21:02 ssuominen Exp $

EAPI=4
inherit libtool

DESCRIPTION="library that handles Resource Description Framework (RDF)"
HOMEPAGE="http://librdf.org/rasqal/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE="+crypt gmp +mhash pcre static-libs test xml"

RDEPEND="media-libs/raptor:2
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )
	!gmp? ( dev-libs/mpfr )
	gmp? ( dev-libs/gmp )
	crypt? (
		!mhash? ( dev-libs/libgcrypt )
		mhash? ( app-crypt/mhash )
		)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/flex
	test? ( dev-perl/XML-DOM )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	elibtoolize
}

src_configure() {
	local regex=posix
	local decimal=mpfr
	local digest=internal

	use pcre && regex=pcre
	use gmp && decimal=gmp

	if use crypt; then
		digest=gcrypt
		use mhash && digest=mhash
	fi

	econf \
		$(use_enable static-libs static) \
		$(use_enable pcre) \
		$(use_enable xml xml2) \
		--with-regex-library=${regex} \
		--with-digest-library=${digest} \
		--with-decimal=${decimal} \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default
	dohtml {NEWS,README,RELEASE}.html
	find "${ED}" -name '*.la' -exec rm -f {} +
}
