# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hoe/hoe-1.8.2.ebuild,v 1.1 2008/10/25 13:58:16 graaff Exp $

inherit gems

DESCRIPTION="Hoe extends rake to provide full project automation."
HOMEPAGE="http://seattlerb.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-ruby/rake-0.8.3
	>=dev-ruby/rubyforge-1.0.1
	>=dev-ruby/rubygems-1.2.0"
