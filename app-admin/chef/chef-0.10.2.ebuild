# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/chef/chef-0.10.2.ebuild,v 1.2 2012/05/31 02:23:21 zmedico Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem user

DESCRIPTION="Chef is a systems integration framework"
HOMEPAGE="http://wiki.opscode.com/display/chef"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/bunny-0.6.0
	dev-ruby/erubis
	dev-ruby/extlib
	dev-ruby/highline
	>=dev-ruby/json-1.4.4
	<=dev-ruby/json-1.5.2
	>=dev-ruby/mixlib-authentication-1.1.0
	>=dev-ruby/mixlib-cli-1.1.0
	>=dev-ruby/mixlib-config-1.1.2
	>=dev-ruby/mixlib-log-1.3.0
	dev-ruby/moneta
	>=dev-ruby/net-ssh-2.1.3
	>=dev-ruby/net-ssh-multi-1.0.1
	>=dev-ruby/ohai-0.6.0
	>=dev-ruby/rest-client-1.0.4
	<dev-ruby/rest-client-1.7.0
	dev-ruby/ruby-shadow
	>=dev-ruby/treetop-1.4.9
	dev-ruby/uuidtools"

all_ruby_install() {
	all_fakegem_install

	keepdir /etc/chef /var/lib/chef /var/log/chef /var/run/chef

	doinitd "${FILESDIR}/initd/chef-client"
	doconfd "${FILESDIR}/confd/chef-client"

	insinto /etc/chef
	doins "${FILESDIR}/client.rb"
	doins "${FILESDIR}/solo.rb"
}

pkg_setup() {
	enewgroup chef
	enewuser chef -1 -1 /var/lib/chef chef
}

pkg_postinst() {
	elog
	elog "You should edit /etc/chef/client.rb before starting the service with"
	elog "/etc/init.d/chef-client start"
	elog
}
