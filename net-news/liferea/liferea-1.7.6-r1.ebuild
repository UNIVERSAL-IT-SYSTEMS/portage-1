# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/liferea/liferea-1.7.6-r1.ebuild,v 1.2 2011/11/19 17:53:22 ssuominen Exp $

EAPI=4

GCONF_DEBUG=no

inherit eutils gnome2 pax-utils

MY_P=${P/_/-}

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo/etc feeds"
HOMEPAGE="http://liferea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="ayatana libnotify"

RDEPEND=">=x11-libs/gtk+-2.18.0:2
	>=dev-libs/glib-2.24.0:2
	>=x11-libs/pango-1.4.0
	>=gnome-base/gconf-1.1.9:2
	dev-libs/json-glib
	dev-libs/libunique:1
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.19
	>=dev-db/sqlite-3.6.10:3
	>=net-libs/libsoup-2.28.2:2.4
	>=net-libs/webkit-gtk-1.2.2:2
	ayatana? ( dev-libs/libindicate )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog README"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-sm
		--disable-schemas-install
		$(use_enable ayatana libindicate)
		$(use_enable libnotify)"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-unread-feeds.patch
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	# bug #338213
	# Uses webkit's JIT. Needs mmap('rwx') to generate code in runtime.
	# MPROTECT policy violation. Will sit here until webkit will
	# get optional JIT.
	pax-mark m "${D}"/usr/bin/liferea

	einfo "If you want to enhance funcitonality of this package"
	einfo "You should consider installing these packages:"
	einfo "    dev-libs/dbus-glib"
	einfo "    net-misc/networkmanager"
}
