# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/cairo/cairo-0.12.3.1.ebuild,v 1.1 2012/05/29 10:37:41 gienah Exp $

EAPI=4

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="lib profile haddock hscolour hoogle nocabaldep"
inherit base haskell-cabal

DESCRIPTION="Binding to the Cairo library."
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+svg"

RDEPEND="dev-haskell/mtl[profile?]
		>=dev-lang/ghc-6.10.1
		x11-libs/cairo[svg?]"
DEPEND="${RDEPEND}
		dev-haskell/gtk2hs-buildtools"

src_configure() {
	# x11-libs/cairo seems to build pdf and ps by default
	cabal_src_configure \
		--flags=cairo_pdf \
		--flags=cairo_ps \
		$(cabal_flag svg cairo_svg)
}
