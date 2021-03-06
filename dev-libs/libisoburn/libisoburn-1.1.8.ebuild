# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libisoburn/libisoburn-1.1.8.ebuild,v 1.6 2012/05/04 18:35:44 jdhore Exp $

EAPI=4

DESCRIPTION="Enables creation and expansion of ISO-9660 filesystems on all CD/DVD media supported by libburn"
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ppc ppc64 x86"
IUSE="acl debug external-filters external-filters-setuid readline static-libs xattr zlib"
#IUSE="acl cdio debug external-filters external-filters-setuid readline static-libs xattr zlib"
#Supports libcdio but needs version >=0.83 which is not yet released.

RDEPEND=">=dev-libs/libburn-1.1.8
	>=dev-libs/libisofs-1.1.6
	acl? ( virtual/acl )
	readline? ( sys-libs/readline )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
#RDEPEND="cdio? ( >=dev-libs/libcdio-0.83 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable readline libreadline) \
	$(use_enable acl libacl) \
	$(use_enable xattr) \
	$(use_enable zlib) \
	--disable-libjte \
	--disable-libcdio \
	$(use_enable external-filters) \
	$(use_enable external-filters-setuid) \
	 --disable-ldconfig-at-install \
	--enable-pkg-check-modules \
	$(use_enable debug)
#	$(use_enable cdio libcdio) \
}

src_install() {
	default

	dodoc CONTRIBUTORS doc/{comments,partition_offset.wiki}

	cd "${S}"/xorriso
	docinto xorriso
	dodoc changelog.txt README_gnu_xorriso

	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}
