# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/epic/epic-0.9.2.ebuild,v 1.1 2012/01/23 12:33:40 gienah Exp $

# ebuild generated by hackport 0.2.14

EAPI="3"

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Compiler for a simple functional language"
HOMEPAGE="http://www.dcs.st-and.ac.uk/~eb/epic.php"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/cabal
		dev-haskell/mtl
		>=dev-libs/boehm-gc-7.0[threads]
		>=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.8.0.4"
