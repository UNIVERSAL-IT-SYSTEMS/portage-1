# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/fwbuilder/fwbuilder-5.0.0.3568.ebuild,v 1.1 2011/12/16 16:28:12 kumba Exp $

EAPI=4

inherit eutils base qt4-r2 multilib autotools

DESCRIPTION="A firewall GUI"
HOMEPAGE="http://www.fwbuilder.org/"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=x11-libs/qt-gui-4.3
	dev-libs/openssl
	dev-libs/elfutils
	sys-devel/gnuconfig"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_prepare() {
	qt4-r2_src_prepare
	eautoreconf

	# This package fundamentally changed its build system.  We have to
	# manually copy config.{sub,guess} from /usr/share/gnuconfig/.
	cp /usr/share/gnuconfig/config.{sub,guess} "${WORKDIR}/${P}/"	\
		|| die "failed to copy config.{sub,guess}"
}

src_configure() {
	eqmake4
	econf
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	validate_desktop_entries

	elog "You need to emerge sys-apps/iproute2 on the machine"
	elog "that will run the firewall script."
}
