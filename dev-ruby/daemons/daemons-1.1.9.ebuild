# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/daemons/daemons-1.1.9.ebuild,v 1.1 2012/08/12 23:13:25 flameeyes Exp $

EAPI=4
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_EXTRADOC="Releases README TODO"
RUBY_FAKEGEM_DOCDIR="html"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Wrap existing ruby scripts to be run as a daemon"
HOMEPAGE="http://daemons.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="examples"

all_ruby_install() {
	all_fakegem_install

	use examples || return

	insinto /usr/share/doc/${PF}/
	doins -r examples
}
