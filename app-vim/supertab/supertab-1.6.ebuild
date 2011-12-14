# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-1.6.ebuild,v 1.5 2011/12/14 08:52:53 phajdan.jr Exp $

EAPI="4"
inherit vim-plugin

MY_PN="SuperTab-continued."
DESCRIPTION="vim plugin: enhanced Tab key functionality"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1643"
SRC_URI="https://github.com/vim-scripts/${MY_PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE=""

VIM_PLUGIN_HELPFILES="supertab"

src_unpack() {
	unpack ${A}
	mv *-${MY_PN}-* "${S}"
}

src_prepare() {
	rm README || die
}
