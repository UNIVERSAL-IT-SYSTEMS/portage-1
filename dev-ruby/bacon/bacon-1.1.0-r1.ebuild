# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bacon/bacon-1.1.0-r1.ebuild,v 1.4 2011/07/24 09:44:07 xarthisius Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README"

inherit ruby-fakegem

DESCRIPTION="Small RSpec clone weighing less than 350 LoC"
HOMEPAGE="http://chneukirchen.org/repos/bacon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RUBY_PATCHES="${FILESDIR}/${P}+ruby-1.9.2.patch"
