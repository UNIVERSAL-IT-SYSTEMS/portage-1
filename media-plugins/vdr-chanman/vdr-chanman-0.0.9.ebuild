# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-chanman/vdr-chanman-0.0.9.ebuild,v 1.1 2012/07/01 18:19:16 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

VERSION="993" # every bump, new version

DESCRIPTION="VDR plugin: change channel with a multi level choice."
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-chanman"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"
