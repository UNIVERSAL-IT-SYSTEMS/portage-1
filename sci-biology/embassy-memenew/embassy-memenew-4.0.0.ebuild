# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-memenew/embassy-memenew-4.0.0.ebuild,v 1.2 2010/01/01 22:03:00 fauli Exp $

EBOV="6.1.0"

inherit embassy

DESCRIPTION="EMBOSS wrappers for MEME - Multiple Em for Motif Elicitation"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-linux ~ppc-macos"

src_install() {
	embassy_src_install
	insinto /usr/include/emboss/meme
	doins src/INCLUDE/*.h
}
