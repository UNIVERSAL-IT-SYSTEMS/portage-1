# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/selenium-webdriver/selenium-webdriver-2.25.0.ebuild,v 1.1 2012/07/20 05:43:26 graaff Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18"

# NOTE: this package contains precompiled code. It appears that all
# source code can be found at http://code.google.com/p/selenium/ but the
# repository is not organized in a way so that we can easily rebuild the
# suited shared object. We'll just try our luck with the precompiled
# objects for now.

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_QA_ALLOWED_LIBS="x_ignore_nofocus.so"

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver."
HOMEPAGE="http://gemcutter.org/gems/selenium-webdriver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/childprocess-0.2.5
	>=dev-ruby/multi_json-1.0.4
	dev-ruby/rubyzip"

all_ruby_prepare() {
	# Make websocket a development dependency since it is only needed
	# for the safari driver which we don't support on Gentoo.
	sed -i -e '/libwebsocket/,/version_requirements/ s/runtime/development/' ../metadata || die
}
