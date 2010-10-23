# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/jaf/jaf-1.1-r1.ebuild,v 1.9 2010/10/22 10:43:33 grobian Exp $

EAPI=1

inherit java-virtuals-2

DESCRIPTION="Virtual for JavaBeans Activation Framework (JAF)"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="|| (
			>=virtual/jre-1.6
			dev-java/sun-jaf:0
			dev-java/gnu-jaf:1
		)
		>=dev-java/java-config-2.1.8
		"

JAVA_VIRTUAL_PROVIDES="sun-jaf gnu-jaf-1"
JAVA_VIRTUAL_VM=">=virtual/jre-1.6"
