# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-0.90.8.ebuild,v 1.2 2012/02/06 17:28:15 ranger Exp $

EAPI="2"
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="${DEPEND}
	>=x11-libs/pango-1.2.1
	>=dev-ruby/rcairo-1.2.0"
RDEPEND="${RDEPEND}
	>=x11-libs/pango-1.2.1
	>=dev-ruby/rcairo-1.2.0"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
