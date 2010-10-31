# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Class/DBIx-Class-0.08124.ebuild,v 1.1 2010/10/31 11:14:17 tove Exp $

EAPI=2

MODULE_AUTHOR=FREW
inherit perl-module

DESCRIPTION="Extensible and flexible object <-> relational mapper"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test admin admin_script deploy replicated"

RDEPEND_MOOSE_BASIC="
	>=dev-perl/Moose-0.98
	>=dev-perl/MooseX-Types-0.21
"
RDEPEND_ADMIN_BASIC="
	>=dev-perl/JSON-Any-1.22
	>=dev-perl/MooseX-Types-JSON-0.02
	>=dev-perl/MooseX-Types-Path-Class-0.05
	>=dev-perl/namespace-autoclean-0.09
"

#	>=dev-perl/Class-DBI-Plugin-DeepAbstractSearch-0.08
#	dev-perl/Class-Trigger
#	>=dev-perl/DBIx-ContextualFetch-1.03
#	>=dev-perl/Date-Simple-3.03
#	dev-perl/DateTime-Format-MySQL
#	dev-perl/DateTime-Format-Pg
#	dev-perl/DateTime-Format-SQLite
#	dev-perl/DateTime-Format-Strptime
#	dev-perl/Devel-Cycle
#	dev-perl/Time-Piece-MySQL

RDEPEND="
	admin? (
		${RDEPEND_MOOSE_BASIC}
		${RDEPEND_ADMIN_BASIC}
	)
	admin_script? (
		${RDEPEND_MOOSE_BASIC}
		${RDEPEND_ADMIN_BASIC}
		>=dev-perl/Getopt-Long-Descriptive-0.081
		>=dev-perl/Text-CSV-1.16
	)
	deploy? (
		>=dev-perl/SQL-Translator-0.11006
	)
	replicated? (
		${RDEPEND_MOOSE_BASIC}
		>=dev-perl/Hash-Merge-0.12
	)
	>=dev-perl/DBD-SQLite-1.29
	>=dev-perl/Carp-Clan-6.00
	>=dev-perl/Class-Accessor-Grouped-0.09008
	>=dev-perl/Class-C3-Componentised-1.0005
	>=dev-perl/Class-Inspector-1.24
	>=dev-perl/Config-Any-0.20
	>=dev-perl/Data-Page-2.01
	>=dev-perl/DBI-1.609
	>=virtual/perl-File-Path-2.08
	>=dev-perl/Math-Base36-0.07
	>=virtual/perl-Math-BigInt-1.89
	>=dev-perl/MRO-Compat-0.11
	>=dev-perl/Module-Find-0.06
	>=dev-perl/Path-Class-0.18
	>=dev-perl/SQL-Abstract-1.69
	>=dev-perl/Sub-Name-0.04
	>=dev-perl/Variable-Magic-0.44
	>=dev-perl/Data-Dumper-Concise-1.000
	>=dev-perl/Scope-Guard-0.03
	dev-perl/Context-Preserve
	>=dev-perl/Try-Tiny-0.04
	>=dev-perl/namespace-clean-0.14
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-File-Temp-0.22
		>=dev-perl/Test-Exception-0.31
		>=dev-perl/Test-Warn-0.21
		>=virtual/perl-Test-Simple-0.92
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
