# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-openvpn/networkmanager-openvpn-0.9.0.ebuild,v 1.3 2012/08/14 04:20:06 tetromino Exp $

EAPI="4"
GNOME_ORG_MODULE="NetworkManager-${PN##*-}"

inherit gnome.org

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk test"

RDEPEND="
	>=dev-libs/dbus-glib-0.74
	>=net-misc/networkmanager-${PV}
	>=net-misc/openvpn-2.1_rc9
	gtk? (
		>=x11-libs/gtk+-2.91.4:3
		gnome-base/gnome-keyring
	)"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

# FAIL: (tls-import-data) unexpected 'ca' secret value
#RESTRICT="test"

src_configure() {
	ECONF="--disable-more-warnings
		--disable-static
		--with-dist-version=Gentoo
		--with-gtkver=3
		$(use_with gtk gnome)
		$(use_with test tests)"

	econf ${ECONF}
}

src_install() {
	default
	# Remove useless .la files
	find "${D}" -name '*.la' -exec rm -f {} +
}
