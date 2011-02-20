# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/NetAddr-IP/NetAddr-IP-4.40.ebuild,v 1.1 2011/02/20 08:00:38 tove Exp $

EAPI=3

MODULE_AUTHOR=MIKER
MODULE_VERSION=4.040
inherit perl-module

DESCRIPTION="Manipulation and operations on IP addresses"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6"

RDEPEND="ipv6? ( dev-perl/Socket6 )"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	touch "${S}"/Makefile.old
}
