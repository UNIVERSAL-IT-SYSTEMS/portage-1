# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/atomix/atomix-2.14.0.ebuild,v 1.7 2012/05/04 04:45:28 jdhore Exp $

EAPI=2
inherit gnome2

DESCRIPTION="a game where you build full molecules, from simple inorganic to extremely complex organic ones"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/atomix/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=x11-libs/pango-1.0.3
	>=x11-libs/gtk+-2.6:2
	>=dev-libs/glib-2.6:2
	>=gnome-base/gconf-2.12
	>=gnome-base/libglade-2.4
	>=gnome-base/libgnome-2.12
	>=gnome-base/libgnomeui-2.12
	>=gnome-base/libbonoboui-2.0.0
	>=gnome-base/libgnomecanvas-2.0.0
	>=dev-libs/libxml2-2.4.23
	dev-perl/XML-Parser"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.17"

DOCS="AUTHORS ChangeLog NEWS README"
