# Copyright 2006-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-ms/myspell-ms-20060316.ebuild,v 1.13 2009/03/30 14:31:57 armin76 Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"ms,MY,ms_MY,Malay (Malaysia),ms_MY.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Malay dictionaries for myspell/hunspell"
LICENSE="FDL-1.2"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
