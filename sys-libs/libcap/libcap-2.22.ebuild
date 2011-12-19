# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcap/libcap-2.22.ebuild,v 1.10 2011/12/18 21:40:16 halcy0n Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs pam

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://www.friedhoff.org/posixfilecaps.html"
SRC_URI="mirror://kernel/linux/libs/security/linux-privs/libcap${PV:0:1}/${P}.tar.bz2"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="pam"

RDEPEND="sys-apps/attr
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.22-build-system-fixes.patch
	epatch "${FILESDIR}"/${PN}-2.22-no-perl.patch
	epatch "${FILESDIR}"/${PN}-2.20-ignore-RAISE_SETFCAP-install-failures.patch
	epatch "${FILESDIR}"/${PN}-2.21-include.patch
	sed -i \
		-e "/^PAM_CAP/s:=.*:=$(usex pam):" \
		-e '/^DYNAMIC/s:=.*:=yes:' \
		-e "/^lib=/s:=.*:=/usr/$(get_libdir):" \
		Make.Rules
}

src_configure() {
	tc-export BUILD_CC CC AR RANLIB
}

src_install() {
	emake install DESTDIR="${D}" || die

	gen_usr_ldscript -a cap

	rm -rf "${D}"/usr/$(get_libdir)/security
	dopammod pam_cap/pam_cap.so
	dopamsecurity '' pam_cap/capability.conf

	dodoc CHANGELOG README doc/capability.notes
}
