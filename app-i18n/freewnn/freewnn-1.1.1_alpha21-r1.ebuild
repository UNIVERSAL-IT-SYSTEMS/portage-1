# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/freewnn/freewnn-1.1.1_alpha21-r1.ebuild,v 1.10 2011/11/07 08:49:51 naota Exp $

inherit eutils

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://freewnn.sourceforge.jp/
	http://www.freewnn.org/"
SRC_URI="mirror://sourceforge.jp/freewnn/17724/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="X ipv6"

DEPEND="X? ( x11-libs/libX11 x11-libs/libXmu x11-libs/libXt )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	#Change WNNOWNER to root so we don't need to add wnn user
	# and disable stripping of binary files
	sed -i -e "s/WNNOWNER = wnn/WNNOWNER = root/" \
		-e "s/@INSTPGMFLAGS@//" makerule.mk.in || die
	# bug #298744
	epatch "${FILESDIR}/${P}-as-needed.patch"

	#bug #318593
	epatch "${FILESDIR}"/${P}-gcc45.patch

	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	econf \
		--disable-cWnn \
		--disable-kWnn \
		--without-termcap \
		$(use_with X x) \
		$(use_with ipv6) \
		|| die
	emake -j1 || die
}

src_install() {
	# install executables, libs ,dictionaries
	emake DESTDIR="${D}" install || die
	# install man pages
	emake DESTDIR="${D}" install.man || die
	# install docs
	dodoc ChangeLog* CONTRIBUTORS
	# install rc script
	newinitd "${FILESDIR}"/freewnn.initd freewnn
}
