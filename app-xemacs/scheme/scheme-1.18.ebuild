# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/scheme/scheme-1.18.ebuild,v 1.5 2011/07/03 08:08:44 hwoarang Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Front-end support for Inferior Scheme."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86"

inherit xemacs-packages
