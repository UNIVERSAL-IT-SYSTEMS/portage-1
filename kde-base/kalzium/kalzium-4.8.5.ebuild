# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalzium/kalzium-4.8.5.ebuild,v 1.1 2012/08/07 11:04:36 johu Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-base flag-o-matic

DESCRIPTION="KDE: periodic table of the elements."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="editor debug +plasma solver"

RDEPEND="
	$(add_kdebase_dep libkdeedu)
	editor? ( >=sci-chemistry/openbabel-2.2 )
"
DEPEND="${RDEPEND}
	editor? ( >=dev-cpp/eigen-2.0.3:2 )
	solver? ( dev-ml/facile[ocamlopt] )
"

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
	libkdeedu/libscience/
"

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	mycmakeargs=(
		$(cmake-utils_use_with editor Eigen2)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with editor OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)
	)

	kde4-base_src_configure
}

src_test(){ :; } #see bug 376911
