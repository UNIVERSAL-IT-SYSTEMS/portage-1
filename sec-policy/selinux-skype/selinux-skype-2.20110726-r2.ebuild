# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-skype/selinux-skype-2.20110726-r2.ebuild,v 1.2 2011/11/27 18:12:40 swift Exp $
EAPI="4"

IUSE=""
MODS="skype"
BASEPOL="2.20110726-r5"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for skype"
KEYWORDS="amd64 x86"
