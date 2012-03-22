# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Module-Pluggable/perl-Module-Pluggable-3.900.0-r1.ebuild,v 1.3 2012/03/21 20:31:54 jer Exp $

DESCRIPTION="Virtual for ${PN#perl-}"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="|| ( =dev-lang/perl-5.14* ~dev-lang/perl-5.12.4 ~dev-lang/perl-5.12.3 ~dev-lang/perl-5.12.2 ~dev-lang/perl-5.10.1 ~perl-core/${PN#perl-}-${PV} )"
