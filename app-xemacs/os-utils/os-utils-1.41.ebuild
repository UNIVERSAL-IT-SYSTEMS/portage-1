# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/os-utils/os-utils-1.41.ebuild,v 1.5 2011/07/03 08:06:27 hwoarang Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Miscellaneous O/S utilities."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86"

inherit xemacs-packages
