# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amatch/amatch-0.2.6.ebuild,v 1.2 2011/07/24 10:33:14 xarthisius Exp $

EAPI=2
USE_RUBY="ruby18 ree18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Approximate Matching Extension for Ruby"
HOMEPAGE="http://flori.github.com/amatch/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/spruz-0.2"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext
	cp ext/amatch$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb tests/* || die
}
