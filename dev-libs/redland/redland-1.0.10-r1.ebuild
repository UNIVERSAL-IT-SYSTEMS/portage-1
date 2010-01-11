# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/redland/redland-1.0.10-r1.ebuild,v 1.4 2010/01/10 09:56:29 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="High-level interface for the Resource Description Framework"
HOMEPAGE="http://librdf.org/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="berkdb iodbc mysql odbc postgres sqlite ssl xml"

RDEPEND="mysql? ( virtual/mysql )
	sqlite? ( =dev-db/sqlite-3* )
	berkdb? ( sys-libs/db )
	xml? ( dev-libs/libxml2 )
	!xml? ( dev-libs/expat )
	ssl? ( dev-libs/openssl )
	>=media-libs/raptor-1.4.17
	>=dev-libs/rasqal-0.9.16
	postgres? ( virtual/postgresql-base )
	iodbc? ( dev-db/libiodbc )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2
	dev-util/gtk-doc-am
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-librdf_storage_register_factory.patch

	sed -i \
		-e '/SHAVE/d' configure.ac || die
	eautoreconf
}

src_configure() {
	use prefix || EPREFIX=
	local parser="expat"

	use xml && parser="libxml"

	local myconf="--without-virtuoso"

	if use iodbc; then
		myconf="--with-virtuoso --with-iodbc --without-unixodbc"
	elif use odbc; then
		myconf="--with-virtuoso --with-unixodbc --without-iodbc"
	fi

	econf \
		--disable-dependency-tracking \
		$(use_with berkdb bdb) \
		--with-xml-parser=${parser} \
		$(use_with ssl openssl-digests) \
		$(use_with mysql) \
		$(use_with sqlite) \
		$(use_with postgres postgresql) \
		--without-threads \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml {FAQS,NEWS,README,RELEASE,TODO}.html
}
