# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libwnck/libwnck-3.4.2.ebuild,v 1.1 2012/05/20 10:34:28 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="A window navigation construction kit"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"

IUSE="doc +introspection startup-notification tools"

RDEPEND=">=x11-libs/gtk+-3.0:3[introspection?]
	>=dev-libs/glib-2.16:2
	x11-libs/libX11
	x11-libs/libXres
	x11-libs/libXext
	introspection? ( >=dev-libs/gobject-introspection-0.6.14 )
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
	x86-interix? ( sys-libs/itx-bind )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"
# eautoreconf needs
#	dev-util/gtk-doc-am
#	gnome-base/gnome-common

pkg_setup() {
	# Don't collide with SLOT=1
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable introspection)
		$(use_enable startup-notification)
		$(use_enable tools)
		--program-suffix=-${SLOT}"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
}

src_prepare() {
	# Regenerate marashalers for <glib-2.31 compat
	rm -v libwnck/wnck-marshal.{c,h} || die

	gnome2_src_prepare

	if use x86-interix; then
		# activate the itx-bind package...
		append-flags "-I${EPREFIX}/usr/include/bind"
		append-ldflags "-L${EPREFIX}/usr/lib/bind"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use tools; then
		elog "wnckprop is now called wnckprop-${SLOT}"
		elog "wnck-urgency-monitor is now called wnck-urgency-monitor-${SLOT}"
	fi
}
