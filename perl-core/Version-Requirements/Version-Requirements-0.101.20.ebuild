# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Version-Requirements/Version-Requirements-0.101.20.ebuild,v 1.15 2012/02/02 19:38:21 ranger Exp $

EAPI=3

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.101020
inherit perl-module

DESCRIPTION="A set of version requirements for a CPAN dist"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ~ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-version-0.77
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
