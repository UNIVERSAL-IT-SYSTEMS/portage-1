# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/expect/expect-5.44.1.ebuild,v 1.6 2010/04/02 09:44:28 jlec Exp $

EAPI="3"

WANT_AUTOCONF="2.5"
inherit autotools eutils

DESCRIPTION="tool for automating interactive applications"
HOMEPAGE="http://expect.nist.gov/"
SRC_URI="http://expect.nist.gov/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="X doc"

# We need dejagnu for src_test, but dejagnu needs expect
# to compile/run, so we cant add dejagnu to DEPEND :/
DEPEND="
	>=dev-lang/tcl-8.2
	>=dev-lang/tk-8.2"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	# fix install_name on darwin
	[[ ${CHOST} == *-darwin* ]] && \
		epatch "${FILESDIR}"/${P}-darwin.patch

	sed -i "s#/usr/local/bin#${EPREFIX}/usr/bin#" expect.man
	sed -i "s#/usr/local/bin#${EPREFIX}/usr/bin#" expectk.man
	#stops any example scripts being installed by default
	sed -i \
		-e '/^install:/s/install-libraries //' \
		-e 's/^SCRIPTS_MANPAGES = /_&/' \
		Makefile.in

	#they forgot to include expect.m4 (now it's in expect cvs)
	cp "${FILESDIR}/expect.m4" .
	#configure broken for testsuite
	sed -i -e 's/^AC_CONFIG_SUBDIRS(testsuite)$//' configure.in
	#fixes "TCL_REG_BOSONLY undeclared" error due to a change in tcl8.5
	sed -i -e 's/^#include "tcl.h"/#include "tclInt.h"/' exp_inter.c
	#slacky destdir support in Makefile
	epatch "${FILESDIR}/${P}-destdir.patch"

	epatch "${FILESDIR}/${P}-gfbsd.patch"

	epatch "${FILESDIR}/${P}-ldflags.patch"

	eautoconf
}

src_configure() {
	local myconf
	local tclv
	local tkv
	# Find the version of tcl/tk that has headers installed.
	# This will be the most recently merged, not necessarily the highest
	# version number.
	tclv=$(grep TCL_VER ${EPREFIX}/usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	#tkv isn't really needed, included for symmetry and the future
	#tkv=$(grep	 TK_VER /usr/include/tk.h  | sed 's/^.*"\(.*\)".*/\1/')

	#configure needs to find the files tclConfig.sh and tclInt.h
	myconf="--with-tcl=${EPREFIX}/usr/$(get_libdir) --with-tclinclude=${EPREFIX}/usr/$(get_libdir)/tcl${tclv}/include/generic"

	if use X ; then
		#--with-x is enabled by default
		#configure needs to find the file tkConfig.sh and tk.h
		#tk.h is in /usr/lib so don't need to explicitly set --with-tkinclude
		myconf="$myconf --with-tk=${EPREFIX}/usr/$(get_libdir) --with-tkinclude=${EPREFIX}/usr/include"
	else
		#configure knows that tk depends on X so just disable X
		myconf="$myconf --without-x"
	fi

	econf $myconf --enable-shared || die "econf failed"
}

src_test() {
	# we need dejagnu to do tests ... but dejagnu needs
	# expect ... so don't do tests unless we have dejagnu
	type -p runtest || return 0
	make check || die "make check failed"
}

src_install() {
	dodir /usr/$(get_libdir)
	make install DESTDIR="${D}" || die "make install failed"

	dodoc ChangeLog FAQ HISTORY NEWS README

	local static_lib="lib${NON_MICRO_V/-/}.a"
	rm "${ED}"/usr/$(get_libdir)/${NON_MICRO_V/-/}/${static_lib}

	#install examples if 'doc' is set
	if use doc ; then
		docinto examples
		local scripts=$(make -qp | \
						sed -e 's/^SCRIPTS = //' -et -ed | head -n1)
		exeinto /usr/share/doc/${PF}/examples
		doexe ${scripts}
		local scripts_manpages=$(make -qp | \
			   sed -e 's/^_SCRIPTS_MANPAGES = //' -et -ed | head -n1)
		for m in ${scripts_manpages}; do
			dodoc example/${m}.man
		done
		dodoc example/README
	fi
}
