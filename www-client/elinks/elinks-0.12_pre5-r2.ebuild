# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/elinks/elinks-0.12_pre5-r2.ebuild,v 1.3 2012/07/04 18:45:08 axs Exp $

EAPI=4
inherit eutils autotools flag-o-matic

MY_P="${P/_/}"
DESCRIPTION="Advanced and well-established text-mode web browser"
HOMEPAGE="http://elinks.or.cz/"
SRC_URI="http://elinks.or.cz/download/${MY_P}.tar.bz2
	http://dev.gentoo.org/~spock/portage/distfiles/elinks-0.10.4.conf.bz2
	http://dev.gentoo.org/~axs/distfiles/${P}-js185-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bittorrent bzip2 debug finger ftp gopher gpm guile idn ipv6 \
	  javascript lua +mouse nls nntp perl ruby samba ssl unicode X zlib"
RESTRICT="test"

DEPEND="dev-libs/boehm-gc
	>=dev-libs/expat-1.95.4
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	X? ( x11-libs/libX11 x11-libs/libXt )
	zlib? ( >=sys-libs/zlib-1.1.4 )
	lua? ( >=dev-lang/lua-5 )
	gpm? ( >=sys-libs/ncurses-5.2 >=sys-libs/gpm-1.20.0-r5 )
	guile? ( >=dev-scheme/guile-1.6.4-r1[deprecated,discouraged] )
	idn? ( net-dns/libidn )
	perl? ( sys-devel/libperl )
	ruby? ( dev-lang/ruby dev-ruby/rubygems )
	samba? ( net-fs/samba )
	javascript? ( dev-lang/spidermonkey )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${WORKDIR}"
	epatch "${FILESDIR}"/${PN}-0.10.4.conf-syscharset.diff
	mv "${PN}-0.10.4.conf" "${PN}.conf"
	if ! use ftp ; then
		sed -i -e 's/\(.*protocol.ftp.*\)/# \1/' ${PN}.conf
	fi
	sed -i -e 's/\(.*set protocol.ftp.use_epsv.*\)/# \1/' ${PN}.conf
	cd "${S}"

	if use lua && has_version ">=dev-lang/lua-5.1"; then
		epatch "${FILESDIR}"/${PN}-0.11.2-lua-5.1.patch
	fi

	epatch "${FILESDIR}"/${PN}-0.11.5-makefile.patch
	epatch "${FILESDIR}"/${P}-compilation-fix.patch

	if use javascript && has_version ">=dev-lang/spidermonkey-1.8"; then
		if has_version ">=dev-lang/spidermonkey-1.8.5"; then
			epatch "${WORKDIR}"/patches/${P}-js185-1-heartbeat.patch
			epatch "${WORKDIR}"/patches/${P}-js185-2-up.patch
			epatch "${WORKDIR}"/patches/${P}-js185-3-histback.patch
			epatch "${FILESDIR}"/${P}-sm185-jsval-fixes.patch
			# expand lib check to also match mozjs187
			if has_version ">=dev-lang/spidermonkey-1.8.7"; then
				sed -i 's:mozjs185:mozjs187 mozjs185:' configure.in
			fi
		else
			epatch "${FILESDIR}"/${MY_P}-spidermonkey-callback.patch
		fi
	fi
	epatch "${FILESDIR}"/${P}-ruby-config.patch

	sed -i -e 's/-Werror//' configure*
	eautoreconf
}

src_configure() {
	# NOTE about GNUTSL SSL support (from the README -- 25/12/2002)
	# As GNUTLS is not yet 100% stable and its support in ELinks is not so well
	# tested yet, it's recommended for users to give a strong preference to OpenSSL whenever possible.
	local myconf=""

	if use debug ; then
		myconf="--enable-debug"
	else
		myconf="--enable-fastmem"
	fi

	if use ssl ; then
		myconf="${myconf} --with-openssl=${EPREFIX}/usr"
	else
		myconf="${myconf} --without-openssl --without-gnutls"
	fi

	econf \
		--sysconfdir="${EPREFIX}"/etc/elinks \
		--enable-leds \
		--enable-88-colors \
		--enable-256-colors \
		--enable-true-color \
		--enable-html-highlight \
		$(use_with gpm) \
		$(use_with zlib) \
		$(use_with bzip2 bzlib) \
		$(use_with X x) \
		$(use_with lua) \
		$(use_with guile) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with idn) \
		$(use_with javascript spidermonkey) \
		$(use_enable bittorrent) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable ftp) \
		$(use_enable gopher) \
		$(use_enable nntp) \
		$(use_enable finger) \
		$(use_enable samba smb) \
		$(use_enable mouse) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	insopts -m 644 ; insinto /etc/elinks
	doins "${WORKDIR}"/elinks.conf
	newins contrib/keybind-full.conf keybind-full.sample
	newins contrib/keybind.conf keybind.conf.sample

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README SITES THANKS TODO doc/*.*
	docinto contrib ; dodoc contrib/{README,colws.diff,elinks[-.]vim*}
	insinto /usr/share/doc/${PF}/contrib/lua ; doins contrib/lua/{*.lua,elinks-remote}
	insinto /usr/share/doc/${PF}/contrib/conv ; doins contrib/conv/*.*
	insinto /usr/share/doc/${PF}/contrib/guile ; doins contrib/guile/*.scm

	# Remove some conflicting files on OSX.  The files provided by OSX 10.4
	# are more or less the same.  -- Fabian Groffen (2005-06-30)
	rm -f "${ED}"/usr/share/locale/locale.alias "${ED}"/usr/lib/charset.alias || die
}

pkg_postinst() {
	einfo "This ebuild provides a default config for ELinks."
	einfo "Please check /etc/elinks/elinks.conf"
	einfo
	einfo "You may want to convert your html.cfg and links.cfg of"
	einfo "Links or older ELinks versions to the new ELinks elinks.conf"
	einfo "using /usr/share/doc/${PF}/contrib/conv/conf-links2elinks.pl"
	einfo
	einfo "Please have a look at /etc/elinks/keybind-full.sample and"
	einfo "/etc/elinks/keybind.conf.sample for some bindings examples."
	einfo
	einfo "You will have to set your TERM variable to 'xterm-256color'"
	einfo "to be able to use 256 colors in elinks."
	echo
}
