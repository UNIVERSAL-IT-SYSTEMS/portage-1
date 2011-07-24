# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/samuel/samuel-0.3.2.ebuild,v 1.8 2011/07/24 09:37:07 xarthisius Exp $

EAPI=2

USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="An automatic logger for HTTP requests in Ruby."
HOMEPAGE="http://github.com/chrisk/samuel"

LICENSE="as-is" # truly
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/shoulda
		dev-ruby/fakeweb
		dev-ruby/httpclient
		virtual/ruby-test-unit
		!dev-ruby/test-unit:2
	)"
