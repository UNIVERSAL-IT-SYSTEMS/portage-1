# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dhcp/selinux-dhcp-2.20110726-r2.ebuild,v 1.2 2012/03/31 12:56:50 swift Exp $
EAPI="4"

IUSE=""
MODS="dhcp"
BASEPOL="2.20110726-r13"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dhcp"

KEYWORDS="amd64 x86"
