# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/objectname/objectname-1.0.0.0.ebuild,v 1.1 2012/06/02 10:57:02 gienah Exp $

EAPI=4

# ebuild generated by hackport 0.2.18.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="ObjectName"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Explicitly handled object names"
HOMEPAGE="http://www.haskell.org/HOpenGL/"
SRC_URI="http://hackage.haskell.org/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.2"
DEPEND="${RDEPEND}
		dev-haskell/cabal"

S="${WORKDIR}/${MY_P}"
