# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/texmath/texmath-0.6.0.4.ebuild,v 1.1 2012/04/07 05:23:08 gienah Exp $

# ebuild generated by hackport 0.2.13

EAPI="4"

CABAL_FEATURES="bin lib profile haddock hscolour hoogle"
inherit haskell-cabal

DESCRIPTION="Conversion of LaTeX math formulas to MathML or OMML."
HOMEPAGE="http://github.com/jgm/texmath"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cgi test"

RDEPEND=">=dev-haskell/parsec-3[profile?]
		dev-haskell/syb[profile?]
		>=dev-haskell/xml-1.3.12[profile?]
		>=dev-lang/ghc-6.8.2
		cgi? ( dev-haskell/json[profile?]
			dev-haskell/cgi[profile?]
			dev-haskell/utf8-string[profile?]
		)
	"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

src_configure() {
	cabal_src_configure \
		$(cabal_flag cgi) \
		$(cabal_flag test)
}

src_install() {
	cabal_src_install

	# remove test and it's data
	rm -f  "${ED}/usr/bin/texmath" 2> /dev/null
	rm -rf "${ED}/usr/share/${P}"/ghc-*/tests 2> /dev/null
}
