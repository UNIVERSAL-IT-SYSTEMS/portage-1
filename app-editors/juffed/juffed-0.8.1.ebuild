# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/juffed/juffed-0.8.1.ebuild,v 1.3 2011/12/14 08:51:38 phajdan.jr Exp $

EAPI=2

inherit multilib cmake-utils

DESCRIPTION="QScintilla-based tabbed text editor with syntax highlighting"
HOMEPAGE="http://www.qt-apps.org/content/show.php/JuffEd?content=59940"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug"

RDEPEND="x11-libs/qscintilla
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P/_/-}

DOCS=( ChangeLog README )

src_prepare() {
	sed -i -e \
		"s:\${CMAKE_INSTALL_PREFIX}/lib:\${CMAKE_INSTALL_PREFIX}/$(get_libdir):" \
		CMakeLists.txt || die "sed failed"
}
