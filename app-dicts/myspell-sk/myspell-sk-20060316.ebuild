# Copyright 2006-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-sk/myspell-sk-20060316.ebuild,v 1.13 2009/03/30 14:32:03 armin76 Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"sk,SK,sk_SK,Slovak (Slovakia),sk_SK.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"sk,SK,hyph_sk_SK,Slovak (Slovakia),hyph_sk_SK.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"sk,SK,th_sk_SK,Slovak (Slovakia),thes_sk_SK.zip"
)

inherit myspell

DESCRIPTION="Slovak dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1 MPL-1.1 myspell-hyph_sk_SK-TiborBako"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
