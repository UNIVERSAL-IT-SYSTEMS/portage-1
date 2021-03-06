# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/curl/curl-1.3.7.ebuild,v 1.4 2012/06/02 01:48:58 gienah Exp $

EAPI=4

# ebuild generated by hackport 0.2.18.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Haskell binding to libcurl"
HOMEPAGE="http://hackage.haskell.org/package/curl"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.2
		net-misc/curl"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.2"
