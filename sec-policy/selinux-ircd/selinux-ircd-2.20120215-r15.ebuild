# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ircd/selinux-ircd-2.20120215-r15.ebuild,v 1.1 2012/07/26 13:07:31 swift Exp $
EAPI="4"

IUSE=""
MODS="ircd"
BASEPOL="2.20120215-r15"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for ircd"

KEYWORDS="~amd64 ~x86"
