# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/puppet/puppet-0.24.6.ebuild,v 1.1 2008/11/21 17:13:40 matsuu Exp $

inherit elisp-common eutils ruby

DESCRIPTION="A system automation and configuration management software"
HOMEPAGE="http://reductivelabs.com/projects/puppet/index.html"
SRC_URI="http://reductivelabs.com/downloads/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
IUSE="emacs ldap rrdtool vim-syntax"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="emacs? ( virtual/emacs )
	>=dev-ruby/facter-1.1.0"
RDEPEND="${DEPEND}
	>=app-portage/eix-0.9.4
	ldap? ( dev-ruby/ruby-ldap )
	rrdtool? (
		|| (
			>=net-analyzer/rrdtool-1.2.23
			dev-ruby/ruby-rrd
		)
	)"
#	|| (
#		www-servers/webrick
#		www-servers/mongrel
#	)
#	dev-ruby/diff-lcs
#	dev-ruby/rails
#	dev-ruby/ruby-shadow

USE_RUBY="ruby18 ruby19"

SITEFILE="50${PN}-mode-gentoo.el"

pkg_setup() {
	built_with_use virtual/ruby ipv6 || \
		die "Ruby must be built with ipv6 support, otherwise puppet will not be able to run"

	if use rrdtool && \
		has_version '>=net-analyzer/rrdtool-1.2.23' && \
		! built_with_use '>=net-analyzer/rrdtool-1.2.23' ruby
	then
		die "net-analyzer/rrdtool must be built with ruby USE flag."
	fi

	enewgroup puppet
	enewuser puppet -1 -1 /var/lib/puppet puppet
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-0.24.2-gentoo.patch"
	epatch "${FILESDIR}/${P}-eix.patch"
}

src_compile() {
	if use emacs ; then
		elisp-compile ext/emacs/puppet-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	DESTDIR="${D}" ruby_einstall "$@" || die
	DESTDIR="${D}" erubydoc

	#
	# bug #237071
	#
	#doinitd conf/gentoo/init.d/puppetmaster
	newinitd "${FILESDIR}"/puppetmaster.init puppetmaster
	#doconfd conf/gentoo/conf.d/puppetmaster
	newconfd "${FILESDIR}"/puppetmaster.confd puppetmaster
	#doinitd conf/gentoo/init.d/puppet
	newinitd "${FILESDIR}"/puppet.init puppet
	doconfd conf/gentoo/conf.d/puppet

	# Initial configuration files
	keepdir /etc/puppet/manifests
	insinto /etc/puppet
	doins conf/gentoo/puppet/*

	# Location of log and data files
	keepdir /var/run/puppet
	keepdir /var/log/puppet
	keepdir /var/lib/puppet/ssl
	keepdir /var/lib/puppet/files
	fowners -R puppet:puppet /var/{run,log,lib}/puppet

	if use emacs ; then
		elisp-install ${PN} ext/emacs/puppet-mode.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use ldap ; then
		insinto /etc/openldap/schema; doins ext/ldap/puppet.schema
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax; doins ext/vim/syntax/puppet.vim
		insinto /usr/share/vim/vimfiles/ftdetect; doins	ext/vim/ftdetect/puppet.vim
	fi

	# ext and examples files
	for f in $(find ext examples -type f) ; do
		docinto "$(dirname ${f})"; dodoc "${f}"
	done
	docinto conf; dodoc conf/namespaceauth.conf
}

pkg_postinst() {
	elog
	elog "Please, *don't* include the --ask option in EMERGE_EXTRA_OPTS as this could"
	elog "cause puppet to hang while installing packages."
	elog
	elog "Puppet uses eix to get information about currently installed	packages,"
	elog "so please keep the eix metadata cache updated so puppet is able to properly"
	elog "handle package installations."
	elog
	elog "Currently puppet only supports adding and removing services to the default"
	elog "runlevel, if you want to add/remove a service from another runlevel you may"
	elog "do so using symlinking."
	elog

	if [ \
		-f "${ROOT}/etc/puppet/puppetd.conf" -o \
		-f "${ROOT}/etc/puppet/puppetmaster.conf" -o \
		-f "${ROOT}/etc/puppet/puppetca.conf" \
	] ; then
		elog
		elog "Please remove deprecated config files."
		elog "	/etc/puppet/puppetca.conf"
		elog "	/etc/puppet/puppetd.conf"
		elog "	/etc/puppet/puppetmasterd.conf"
		elog
	fi
	use emacs && elisp-site-regen
}
pkg_postrm() {
	use emacs && elisp-site-regen
}
