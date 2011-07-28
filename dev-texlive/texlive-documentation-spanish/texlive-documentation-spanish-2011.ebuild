# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-spanish/texlive-documentation-spanish-2011.ebuild,v 1.1 2011/07/28 13:12:15 aballier Exp $

EAPI="3"

TEXLIVE_MODULE_CONTENTS="es-tex-faq l2tabu-spanish latex2e-help-texinfo-spanish latexcheat-esmx lshort-spanish collection-documentation-spanish
"
TEXLIVE_MODULE_DOC_CONTENTS="es-tex-faq.doc l2tabu-spanish.doc latex2e-help-texinfo-spanish.doc latexcheat-esmx.doc lshort-spanish.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit  texlive-module
DESCRIPTION="TeXLive Spanish documentation"

LICENSE="GPL-2 as-is LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2011
"
RDEPEND="${DEPEND} "
