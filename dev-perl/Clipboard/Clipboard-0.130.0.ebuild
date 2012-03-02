# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Clipboard/Clipboard-0.130.0.ebuild,v 1.3 2012/03/01 20:06:33 ranger Exp $

EAPI=4

MODULE_AUTHOR=KING
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Copy and paste with any OS"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="x11-misc/xclip"
