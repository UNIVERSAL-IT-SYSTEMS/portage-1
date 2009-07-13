# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vcdgear/vcdgear-1.76-r2.ebuild,v 1.4 2009/07/12 15:51:51 ssuominen Exp $

EAPI=2

QA_PRESTRIPPED=/opt/vcdgear/vcdgear
QA_DT_HASH=/opt/vcdgear/vcdgear

STAMP=040415
DESCRIPTION="extract MPEG streams from CD images, convert VCD files to MPEG, correct MPEG errors, and more"
HOMEPAGE="http://www.vcdgear.com/"
SRC_URI="http://www.vcdgear.com/files/vcdgear${PV//.}-${STAMP}_linux.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="virtual/libstdc++:3.3"
DEPEND=""

S=${WORKDIR}/${PN}

src_install() {
	insinto /opt/vcdgear
	doins -r * || die "doins"
	fperms a+rx /opt/vcdgear/vcdgear
	dodir /opt/bin
	dosym /opt/vcdgear/vcdgear /opt/bin/vcdgear
}
