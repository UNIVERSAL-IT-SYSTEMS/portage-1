# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-glib2/ruby-glib2-0.90.8.ebuild,v 1.1 2011/05/29 14:00:44 naota Exp $

EAPI="3"
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="${RDEPEND} >=dev-libs/glib-2"
DEPEND="${DEPEND}
	>=dev-libs/glib-2"
ruby_add_bdepend "dev-ruby/pkg-config"

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}
