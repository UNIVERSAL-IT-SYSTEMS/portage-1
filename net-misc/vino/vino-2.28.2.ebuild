# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vino/vino-2.28.2.ebuild,v 1.9 2010/09/06 13:09:00 pacho Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="avahi crypt ipv6 jpeg gnome-keyring libnotify networkmanager ssl +telepathy zlib"

RDEPEND=">=dev-libs/glib-2.17
	>=x11-libs/gtk+-2.16
	>=gnome-base/gconf-2
	>=sys-apps/dbus-1.2.3
	>=net-libs/libsoup-2.24:2.4
	>=dev-libs/libunique-1
	dev-libs/dbus-glib
	x11-libs/libXext
	x11-libs/libXtst
	libnotify? ( >=x11-libs/libnotify-0.4.4 )
	gnome-keyring? ( || ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 ) )
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	crypt? ( >=dev-libs/libgcrypt-1.1.90 )
	jpeg? ( media-libs/jpeg )
	networkmanager? ( >=net-misc/networkmanager-0.7 )
	ssl? ( >=net-libs/gnutls-1 )
	telepathy? ( >=net-libs/telepathy-glib-0.7.31 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	|| ( gnome-base/libgnome-keyring <gnome-base/gnome-keyring-2.29.4 )"
# keyring is always required at build time per bug 322763

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable avahi)
		$(use_enable crypt gcrypt)
		$(use_enable ipv6)
		$(use_with jpeg)
		$(use_enable gnome-keyring)
		$(use_enable libnotify)
		$(use_enable networkmanager network-manager)
		$(use_enable ssl gnutls)
		$(use_enable telepathy)
		$(use_with zlib)
		$(use_with zlib libz)
		--enable-libunique"
}

src_prepare() {
	gnome2_src_prepare

	# Fix autorestart loop, bug #277989
	epatch "${FILESDIR}/${PN}-2.26.2-autorestart-loop.patch"

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	elog "If you are getting refresh problems when using special 3D effects,"
	elog "try disabling XDamage extension. For that, you can run the following:"
	elog " gconftool-2 --type boolean --set /desktop/gnome/remote_access/disable_xdamage true"
	elog "This is due http://bugs.freedesktop.org/12255"
}
