# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pv/pv-1.2.0-r1.ebuild,v 1.7 2012/07/14 11:34:32 maekke Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="http://www.ivarch.com/programs/pv.shtml"
SRC_URI="http://pipeviewer.googlecode.com/files/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc64-solaris ~x86-solaris"

IUSE="nls"
PV_LINGUAS="de fr pl pt"
for lingua in ${PV_LINGUAS}; do
	IUSE+=" linguas_${lingua}"
done

DOCS=( README doc/NEWS doc/TODO )

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake LD="$(tc-getLD)"
}

src_install() {
	default
	local lingua=""
	for lingua in ${PV_LINGUAS}; do
		if ! use linguas_$lingua; then
				rm -rf "${D}"/usr/share/locale/$lingua || die
		fi
	done
}
