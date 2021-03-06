# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ascii85/ascii85-1.0.1.ebuild,v 1.9 2012/08/14 00:56:40 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.txt"

RUBY_FAKEGEM_NAME="Ascii85"

inherit ruby-fakegem

DESCRIPTION="Methods for encoding/decoding Adobe's binary-to-text encoding of the same name."
HOMEPAGE="http://ascii85.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
