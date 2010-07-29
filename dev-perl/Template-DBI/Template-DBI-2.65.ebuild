# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Template-DBI/Template-DBI-2.65.ebuild,v 1.1 2010/07/29 06:44:47 tove Exp $

EAPI=3

MODULE_AUTHOR=REHSACK
inherit perl-module

DESCRIPTION="DBI plugin for the Template Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86 ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/DBI-1.612
	>=dev-perl/Template-Toolkit-2.22"
DEPEND="${RDEPEND}
	test? ( dev-perl/MLDBM
		>=dev-perl/SQL-Statement-1.28 )"

SRC_TEST="do"
