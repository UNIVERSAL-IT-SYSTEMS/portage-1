# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-czechslovak/texlive-documentation-czechslovak-2011.ebuild,v 1.1 2011/07/28 12:50:00 aballier Exp $

EAPI="3"

TEXLIVE_MODULE_CONTENTS="lshort-czech lshort-slovak texlive-cz collection-documentation-czechslovak
"
TEXLIVE_MODULE_DOC_CONTENTS="lshort-czech.doc lshort-slovak.doc texlive-cz.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Czech/Slovak documentation"

LICENSE="GPL-2 GPL-1 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2011
"
RDEPEND="${DEPEND} "
