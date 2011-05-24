# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdesktop-agnostic/libdesktop-agnostic-0.3.92.ebuild,v 1.3 2011/05/24 15:49:00 angelos Exp $

EAPI=3
PYTHON_DEPEND="2"
inherit python waf-utils

DESCRIPTION="A desktop-agnostic library for GLib-based projects"
HOMEPAGE="https://launchpad.net/libdesktop-agnostic"
SRC_URI="http://launchpad.net/${PN}/0.4/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +gconf glade gnome introspection"

RDEPEND="dev-libs/glib:2
	dev-python/pygobject:2
	dev-python/pygtk:2
	x11-libs/gtk+:2
	gconf? ( gnome-base/gconf:2 )
	glade? ( gnome-base/libglade:2.0 )
	gnome? ( gnome-base/gnome-desktop:2 )"
DEPEND="${RDEPEND}
	dev-lang/vala:0.10[vapigen]
	dev-libs/gobject-introspection
	introspection? ( x11-libs/gtk+:2[introspection] )"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	local cfg="keyfile" fdo="glib" myconf=""

	use gconf && cfg="gconf,${cfg}"
	use gnome && fdo="${fdo},gnome"
	use debug && myconf="${myconf} --enable-debug"
	use glade && myconf="${myconf} --enable-glade"
	use introspection || myconf="${myconf} --disable-gi"

	VALAC=$(type -p valac-0.10) \
	waf-utils_src_configure \
		--sysconfdir="${EPREFIX}"/etc \
		--config-backends=${cfg} \
		--desktop-entry-backends=${fdo} \
		--vfs-backends=gio \
		${myconf}
}
