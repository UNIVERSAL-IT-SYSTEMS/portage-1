# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/dev-manager/dev-manager-0.ebuild,v 1.3 2011/12/20 23:46:58 vapier Exp $

EAPI="2"

DESCRIPTION="Virtual for the device filesystem manager"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
		sys-fs/udev
		sys-apps/busybox[mdev]
		sys-fs/devfsd
		sys-fs/static-dev
		sys-freebsd/freebsd-sbin
	)"
