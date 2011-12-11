# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/youtube-dl/youtube-dl-2011.11.22.ebuild,v 1.3 2011/12/11 00:42:03 floppym Exp $

EAPI=3
PYTHON_DEPEND=2:2.5

inherit python

DESCRIPTION="A small command-line program to download videos from YouTube."
HOMEPAGE="http://rg3.github.com/youtube-dl/"
SRC_URI="http://github.com/rg3/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

pkg_setup() { :; }

src_install() {
	newbin rg3-${PN}*/${PN} ${PN} || die
	python_convert_shebangs -r 2 "${D}"
}
