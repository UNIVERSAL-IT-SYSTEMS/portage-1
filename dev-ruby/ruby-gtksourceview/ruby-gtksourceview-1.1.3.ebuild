# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtksourceview/ruby-gtksourceview-1.1.3.ebuild,v 1.4 2012/08/17 13:04:19 johu Exp $

EAPI="2"
USE_RUBY="ruby18 ruby19 ree18"

RUBY_FAKEGEM_NAME="gtksourceview2"

inherit ruby-ng-gnome2

S=${WORKDIR}/ruby-gnome2-all-${PV}/gtksourceview2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${RDEPEND}
	x11-libs/gtksourceview:2.0"
DEPEND="${DEPEND}
	x11-libs/gtksourceview:2.0
	virtual/pkgconfig"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"
